/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://www.informatik.uni-kiel.de/rtsys/kieler/
 * 
 * Copyright 2013 by
 * + Christian-Albrechts-University of Kiel
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License (EPL).
 * See the file epl-v10.html for the license text.
 */
package de.cau.cs.kieler.scg.sequentializer

import com.google.inject.Guice
import com.google.inject.Inject
import de.cau.cs.kieler.core.kexpressions.Expression
import de.cau.cs.kieler.core.kexpressions.KExpressionsFactory
import de.cau.cs.kieler.core.kexpressions.OperatorType
import de.cau.cs.kieler.core.kexpressions.ValuedObject
import de.cau.cs.kieler.core.kexpressions.extensions.KExpressionsExtension
import de.cau.cs.kieler.scg.Assignment
import de.cau.cs.kieler.scg.BasicBlock
import de.cau.cs.kieler.scg.ControlFlow
import de.cau.cs.kieler.scg.Join
import de.cau.cs.kieler.scg.Node
import de.cau.cs.kieler.scg.Predecessor
import de.cau.cs.kieler.scg.SCGraph
import de.cau.cs.kieler.scg.ScgFactory
import de.cau.cs.kieler.scg.Schedule
import de.cau.cs.kieler.scg.SchedulingBlock
import de.cau.cs.kieler.scg.extensions.SCGCacheExtensions
import de.cau.cs.kieler.scg.extensions.SCGExtensions
import de.cau.cs.kieler.scg.extensions.UnsupportedSCGException
import de.cau.cs.kieler.scg.synchronizer.SurfaceSynchronizer
import java.util.HashMap
import java.util.List

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import de.cau.cs.kieler.scg.BranchType
import de.cau.cs.kieler.core.kexpressions.ValueType

/** 
 * This class is part of the SCG transformation chain. The chain is used to gather important information 
 * about the schedulability of a given SCG. This is done in several key steps. Between two steps the results 
 * are cached in specifically designed metamodels for further processing. At the end of the transformation
 * chain a newly generated (and sequentialized) SCG is returned. <br>
 * You can either call the transformations manually or use the SCG transformation extensions to enrich the
 * SCGs with the desired information.<br>
 * <pre>
 * SCG 
 *   |-- Dependency Analysis 	 					
 *   |-- Basic Block Analysis				
 *   |-- Scheduler
 *   |-- Sequentialization (new SCG)	<== YOU ARE HERE
 * </pre>
 * 
 * @author ssm
 * @kieler.design 2013-12-05 proposed 
 * @kieler.rating 2013-12-05 proposed yellow
 */

class SimpleSequentializer extends AbstractSequentializer {

    // -------------------------------------------------------------------------
    // -- Injections 
    // -------------------------------------------------------------------------
    
    /** Inject SCG extensions. */  
    @Inject 
    extension SCGExtensions
    
    /** Inject SCG cache extensions. */
    @Inject
    extension SCGCacheExtensions    
     
    /** Inject SCG copy extensions. */  
    @Inject 
    extension KExpressionsExtension	

    
    // -------------------------------------------------------------------------
    // -- Globals
    // -------------------------------------------------------------------------
           
//    private val AdditionalConditionals = new HashMap<ConditionalAddition, Conditional>         
    
    protected val guardExpressionCache = new HashMap<ValuedObject, GuardExpression>   

    protected val schedulingBlockCache = new HashMap<Node, SchedulingBlock>

    protected val predecessorTwinCache = new HashMap<Predecessor, Predecessor>
    protected val predecessorBBCache = new HashMap<BasicBlock, List<Predecessor>>    
    protected val predecessorSBCache = new HashMap<Predecessor, List<SchedulingBlock>>
    protected val predecessorTwinMark = <SchedulingBlock, Boolean> newHashMap
               
    // -------------------------------------------------------------------------
    // -- Transformation method
    // -------------------------------------------------------------------------    
      
    /**
     * transformSCGSchedToSeqSCG executes the transformation of an SCG with scheduling information to an
     * standard SCG without any further information. Naturally, the SCG will only consist of an 
     * entry-exit node pair and a series of assignment and conditionals.<br>
     * <strong>This amalgamation of nodes constitutes the tick function of the circuit approach.</strong>
     * 
     * @param scgsched
     * 			the source SCG with scheduling information
     * @return Returns a sequentialized standard SCG.
     */    
     override SCGraph sequentialize(SCGraph scg) {
        // Create new standard SCG with the Scg factory.
        val timestamp = System.currentTimeMillis
          
        /**
         * Since we want to build a new SCG, we cannot use the SCG copy extensions because it would 
         * preserve all previous (node) data.
         * Therefore, we only copy the interface and extend the declaration by the guards of the 
         * basic blocks.
         */
        val newSCG = ScgFactory::eINSTANCE.createSCGraph
		val predecessorList = <Predecessor> newArrayList
		val basicBlockList = <BasicBlock> newArrayList
        scg.copyDeclarations(newSCG)
       	val guardDeclaration = createDeclaration=>[ setType(ValueType::BOOL) ]
       	newSCG.declarations += guardDeclaration
        scg.basicBlocks.forEach[
        	basicBlockList += it
        	predecessorList += it.predecessors
            schedulingBlocks.forEach[
                val vo = createValuedObject(it.guard.name) => [ guardDeclaration.valuedObjects += it ]
                it.guard.addToValuedObjectMapping(vo)
        		it.nodes.forEach[ node | schedulingBlockCache.put(node, it) ]
            ]
        ]
        val vo = newSCG.createGOSignal
        vo.addToValuedObjectMapping(vo)
        
//        guardExpressionCache.clear
//        scgSched.basicBlocks.map[guard].forEach[guard |
//        	guardExpressionCache.put(guard.valuedObject, guard)
//        ]

        var time = (System.currentTimeMillis - timestamp) as float
        System.out.println("Preparation for sequentialization: caches finished (time elapsed: "+(time / 1000)+"s).")          


        predecessorList.forEach[ p |
            if (p.branchType == BranchType::TRUEBRANCH) {
                p.cacheTwin(basicBlockList)
            } 
            else if (p.branchType == BranchType::ELSEBRANCH) {
                p.cacheTwin(basicBlockList)
            }
        ]
        
//        scg.createSchedulingBlockCache(schedulingBlockCache)
        
        time = (System.currentTimeMillis - timestamp) as float
        System.out.println("Preparation for sequentialization finished (time elapsed: "+(time / 1000)+"s).")          
        
		// Create the entry node, a control flow for the entry node, add the node.
        val entry = ScgFactory::eINSTANCE.createEntry
    	val entryFlow = ScgFactory::eINSTANCE.createControlFlow
    	entry.next = entryFlow
        newSCG.nodes.add(entry)
        
        // Now, call the worker method. It returns the last control flows which have to be connected to the exit node.
        val nodeCache = <Node> newLinkedList
        val exitFlows = scg.schedules.head.transformSchedule(newSCG, entryFlow, nodeCache)
        
        // Create an exit node and connect the control flow. Add the node.
        val exit = ScgFactory::eINSTANCE.createExit
        exitFlows.forEach[it.target = exit]
        nodeCache.add(exit)
        
        newSCG.nodes += nodeCache
        
        time = (System.currentTimeMillis - timestamp) as float
        System.out.println("Sequentialization finished (overall time elapsed: "+(time / 1000)+"s).")  
                
        // Return the SCG.
        newSCG     	
    }
    
    /**
     * This worker function takes the scheduling information of an enriched SCG and creates the nodes of
     * a sequentialized SCG. 
     * 
     * @param schedule
     * 			the scheduling information
     * @param scg
     * 			the target SCG
     * @param controlFlow
     * 			the source control flow which points to the next node
     * @return Returns a list of outgoing control flows. The caller should connect them to their surrounding environment. 
     * @throws UnsupportedSCGException
     * 			if no guard expression can be found for a specific guard.
     */
    protected def transformSchedule(Schedule schedule, SCGraph scg, ControlFlow controlFlow, List<Node> nodeCache) {
    	// The source SCG is easily determined as it includes the schedule. Its container is the source SCG.
    	val scgSched = schedule.eContainer as SCGraph
    	
    	// Since the last node maybe a conditional node, it is possible to conclude the schedule with more than one
    	// outgoing control flow. Create a list to hold the control flows and add the incoming one.
    	val nextFlows = <ControlFlow> newArrayList
    	nextFlows.add(controlFlow)
    	
//    	val processedBlockGuards = <SchedulingBlock, Boolean> newHashMap
    	
    	// For each scheduling block in the schedule iterate.
    	for (sb : schedule.schedulingBlocks) {
    		/**
    		 * Each scheduling block references a guard. Each guard results in an assignment. 
    		 * Create it and copy the corresponding object.
    		 */
//            if (!processedBlockGuards.get(sb) == true) {
//
//                processedBlockGuards.put(sb, true)

		  	   /**
    			 * For each guard a guard expression exists.
	   		     * Retrieve the expression and test it for null. 
		  	     * If the guard expression is null, the scheduler could not create an expression for this guard. This is bad. Perhaps the SCG is erroneous. Throw an exception.
			     * Otherwise, it is possible that the guard expression houses empty expressions for a synchronizer. Add them as well.
			     */    		
    			// Retrieve the guard expression from the scheduling information.
        		createAndAddGuardExpression(sb, nextFlows, schedule, scg, nodeCache) 
//    		}
    		
    		/**
    		 * If the scheduling block includes assignment nodes, they must be executed if the corresponding guard 
    		 * evaluates to true. Therefore, create a conditional for the guard and add the assignment to the
    		 * true branch. They will execute their expression if the guard is active in this tick instance. 
    		 */
    		if (sb.nodes.filter(typeof(Assignment)).size>0)
    		{
    			// Create a conditional and set a reference of the guard as condition.
    			val conditional = ScgFactory::eINSTANCE.createConditional
                conditional.condition = sb.guard.reference.copySCGExpression
    			
    			// Create control flows for the two branches and set the actual control flow to the conditional.
    			conditional.then = ScgFactory::eINSTANCE.createControlFlow
    			conditional.^else = ScgFactory::eINSTANCE.createControlFlow
    			nextFlows.forEach[ target = conditional ]
    			nextFlows.clear
    			
    			// Add the conditional.
    			nodeCache.add(conditional)
    			
    			// Now, use the SCG copy extensions to copy the assignment and connect them appropriately
    			// in the true branch of the conditional.
    			var nextCFlow = conditional.then
    			for (assignment : sb.nodes.filter(typeof(Assignment))) {
    				val Assignment cAssignment = assignment.copySCGNode(scg) as Assignment
    				nextCFlow.target = cAssignment
    				nodeCache.add(cAssignment)
    				nextCFlow = ScgFactory::eINSTANCE.createControlFlow
    				cAssignment.next = nextCFlow
    			}
    			nextFlows.add(nextCFlow)
    			
    			// Subsequently, add the last control flow of the true branch and the control flow of the
    			// else branch to the control flow list. These are the new entry flows for the next assignment
    			// or the return value (in which case they will be connected to the exit node by the caller). 
    			nextFlows.add(conditional.^else)

    		}
    		
     	}
    	
    	// Return any remaining control flows for the caller.
    	nextFlows
    }
    
    def Assignment copySCGNode(Assignment node, SCGraph target) {
    	val assignment = ScgFactory::eINSTANCE.createAssignment
//        assignment.assignment = TRUE 
        assignment.assignment = node.assignment.copySCGExpression
        assignment.valuedObject = node.valuedObject.getValuedObjectCopyWNULL;
        for(index : node.indices) {	assignment.indices += index.copySCGExpression }
        assignment
    } 
    
    protected def addGuardExpression(Assignment assignment, GuardExpression guardExpression, 
        List<ControlFlow> nextFlows, SCGraph scg, List<Node> nodeCache
    ) {
        guardExpression.emptyExpressions.forEach[
            val vo = scg.createValuedObject(it.valuedObject.name).setTypeBool
            it.valuedObject.addToValuedObjectMapping(vo)                        
            val eeAssignment = ScgFactory::eINSTANCE.createAssignment
            eeAssignment.valuedObject = it.valuedObject.getValuedObjectCopy
            eeAssignment.assignment = it.expression.copySCGExpression
            nodeCache.add(eeAssignment)
            nextFlows.forEach[it.target = eeAssignment]
            nextFlows.clear                 
            val nextFlow = ScgFactory::eINSTANCE.createControlFlow
            eeAssignment.next = nextFlow
            nextFlows.add(nextFlow)
        ]
        // Then, copy the expression of the guard to the newly created assignment.
        assignment.assignment = guardExpression.expression.copySCGExpression    
    }    
    
    
    
    /**
     * createGuardExpression creates an expression for a guard of a specific scheduling block.
     * 
     * @param schedulingBlock
     *          the scheduling block in question.
     * @param scg
     *          the SCG
     * @return Returns the guard expression.
     * @throws UnsupportedSCGException 
     *      Throws an UnsupportedSCGException if a standard guarded block has no predecessor information.
     */
    protected def void createAndAddGuardExpression(SchedulingBlock schedulingBlock, 
        List<ControlFlow> nextFlows, Schedule schedule, SCGraph scg, List<Node> nodeCache
    ) {
        var GuardExpression gExpr
        
        // Query the basic block of the scheduling block.
        val basicBlock = schedulingBlock.basicBlock
        
        val assignment = ScgFactory::eINSTANCE.createAssignment
        assignment.valuedObject = schedulingBlock.guard.getValuedObjectCopy        
        
        /** 
         * If the scheduling block is the first scheduling block in the basic block,
         * create an appropriate expression for the activity state of this guard.
         * A more accurate description of the interconnectivity between the activity states
         * of the basic blocks can be found in rtsys:ssm-dt, 2013.
         */
         
        // Is the scheduling block the first scheduling block of the basic block?
        if (basicBlock.schedulingBlocks.head == schedulingBlock) {
            if (basicBlock.goBlock) {
                /**
                 * If the basic block is a GO block, meaning it should be active when the programs starts,
                 * add a reference to the GO signal as expression for the guard.
                 */
                 schedulingBlock.handleGoBlockGuardExpression(assignment, nextFlows, schedule, scg, nodeCache)
            } 
            else if (basicBlock.depthBlock) {
                /**
                 * If the basic block is a depth block, meaning it is delayed in its execution,
                 * add a pre operator expression as expression for the guard.
                 */
                schedulingBlock.handleDepthBlockGuardExpression(assignment, nextFlows, schedule, scg, nodeCache)
            }
            else if (basicBlock.synchronizerBlock) {
                /**
                 * If the basic block is a surface block, meaning it is responsible for joining concurrent threads,
                 * invoke a synchronizer. The synchronizer will create the guard expression for this node.
                 * Additionally, the synchronizer may create new valued objects mandatory for the expression.
                 * These must be added to the graph in order to be serializable later on. 
                 */
                schedulingBlock.handleSynchronizerBlockGuardExpression(assignment, nextFlows, schedule, scg, nodeCache)   
            } else {
                /**
                 * If the block is neither of them, it solely depends on the activity states of previous basic blocks.
                 * At least one block must be active to activate the current block. Therefore, connect all guards
                 * of the predecessors with OR expressions.
                 */
                schedulingBlock.handleStandardBlockGuardExpression(assignment, nextFlows, schedule, scg, nodeCache)               
            }
        } else {
            /**
             * If the scheduling block is not the first scheduling block in the basic block, it is active 
             * if and only if its basic block, and in this case the first scheduling block of the basic block,
             * is active but possibly at a later stage in the net list. Add a reference of the guard of the first
             * scheduling block as expression.
             * 
             * HINT: There were some concerns that the expression would maybe evaluate differently at a later stage in 
             * the net list and that the whole expression must be re-evaluated at that particular point of time.
             * However, due to the rules valid for the basic block and scheduling block creation, this scenario 
             * cannot occur. A difference of guard evaluation with respect to data dependencies can only occur 
             * between conditional nodes but conditional nodes force the create of new basic blocks after their execution.
             * Therefore, there will always be a new basic block with a new guard expression in this scenario.
             */
            schedulingBlock.handleSubsequentSchedulingBlockGuardExpression(assignment, nextFlows, schedule, scg, nodeCache)
        }
                
        // Connect all control flows to the new assignment and clear the list.
        nextFlows.forEach[ target = assignment ]
        nextFlows.clear
            
        // Create a new control flow and take the assignment node as source.
        val nextFlow = ScgFactory::eINSTANCE.createControlFlow
        assignment.next = nextFlow
        nextFlows.add(nextFlow)
            
        // Add the assignment to the SCG.
        nodeCache.add(assignment)
    }
    
    
    // --- CREATE GUARDS: GO BLOCK 
    
    protected def handleGoBlockGuardExpression(SchedulingBlock schedulingBlock, Assignment assignment,  
        List<ControlFlow> nextFlows, Schedule schedule, SCGraph scg, List<Node> nodeCache
    ) {
        val gExpr = schedulingBlock.createGoBlockGuardExpression(schedule, scg)
        assignment.addGuardExpression(gExpr, nextFlows, scg, nodeCache)       
    }
    
    protected def GuardExpression createGoBlockGuardExpression(SchedulingBlock schedulingBlock, Schedule schedule, SCGraph scg) {
        new GuardExpression => [
            valuedObject = schedulingBlock.guard
            expression = scg.findValuedObjectByName(GOGUARDNAME).reference
        ]
    }
    

    // --- CREATE GUARDS: DEPTH BLOCK 

    protected def handleDepthBlockGuardExpression(SchedulingBlock schedulingBlock, Assignment assignment,  
        List<ControlFlow> nextFlows, Schedule schedule, SCGraph scg,  List<Node> nodeCache
    ) {
        val gExpr = schedulingBlock.createDepthBlockGuardExpression(schedule, scg)
        assignment.addGuardExpression(gExpr, nextFlows, scg, nodeCache)       
    }
    
    protected def GuardExpression createDepthBlockGuardExpression(SchedulingBlock schedulingBlock, Schedule schedule, SCGraph scg) {
        new GuardExpression => [
            valuedObject = schedulingBlock.guard
            expression = KExpressionsFactory::eINSTANCE.createOperatorExpression => [
                setOperator(OperatorType::PRE)
                subExpressions.add(schedulingBlock.basicBlock.preGuard.reference)
            ]
        ]
    }


    // --- CREATE GUARDS: SYNCHRONIZER BLOCK 

    protected def handleSynchronizerBlockGuardExpression(SchedulingBlock schedulingBlock, Assignment assignment,  
        List<ControlFlow> nextFlows, Schedule schedule, SCGraph scg,  List<Node> nodeCache
    ) {
        val gExpr = schedulingBlock.createSynchronizerBlockGuardExpression(schedule, scg)
        assignment.addGuardExpression(gExpr, nextFlows, scg, nodeCache)       
    }
    
    protected def GuardExpression createSynchronizerBlockGuardExpression(SchedulingBlock schedulingBlock, Schedule schedule, SCGraph scg) {
        // The simple scheduler uses the SurfaceSynchronizer. 
        // The result of the synchronizer is stored in the synchronizerData class joinData.
        val SurfaceSynchronizer synchronizer = Guice.createInjector().getInstance(typeof(SurfaceSynchronizer))
        synchronizer.setSchedulingCache(schedulingBlockCache)
        val joinData = synchronizer.synchronize(schedulingBlock.nodes.head as Join)

        joinData.guardExpression
    }
    
    
    // --- CREATE GUARDS: STANDARD BLOCK 

    protected def handleStandardBlockGuardExpression(SchedulingBlock schedulingBlock, Assignment assignment,  
        List<ControlFlow> nextFlows, Schedule schedule, SCGraph scg,  List<Node> nodeCache
    ) {
        val gExpr = schedulingBlock.createStandardBlockGuardExpression(schedule, scg)
        assignment.addGuardExpression(gExpr, nextFlows, scg, nodeCache)       
    }
    
    protected def GuardExpression createStandardBlockGuardExpression(SchedulingBlock schedulingBlock, Schedule schedule, SCGraph scg) {
        val basicBlock = schedulingBlock.basicBlock
        
        val gExpr = new GuardExpression;
        gExpr.valuedObject = schedulingBlock.guard
        
        // If there are more than one predecessor, create an operator expression and connect them via OR.
        if (basicBlock.predecessors.size>1) {
            // Create OR operator expression via kexpressions factory.
            val expr = KExpressionsFactory::eINSTANCE.createOperatorExpression
            expr.setOperator(OperatorType::OR)
                    
            // For each predecessor add its expression to the sub expressions list of the operator expression.
            basicBlock.predecessors.forEach[ expr.subExpressions += it.predecessorExpression(schedulingBlock, schedule, scg) ]
            gExpr.expression = expr
        } 
        // If it is exactly one predecessor, we can use its expression directly.
        else if (basicBlock.predecessors.size == 1) {
            gExpr.expression = basicBlock.predecessors.head.predecessorExpression(schedulingBlock, schedule, scg)
        } 
        else 
        {
            /**
            * If we reach this point, the basic block contains no predecessor information but is not marked as go block.
            * This is not supported by this scheduler: throw an exception. 
            */
            if (!basicBlock.deadBlock) {
                throw new UnsupportedSCGException("Cannot handle standard guard without predecessor information!")
            } else {
                gExpr.expression = FALSE  
            }
        }
        gExpr       
    }


    // --- CREATE GUARDS: SUBSEQUENT SCHEDULING BLOCK 

    protected def handleSubsequentSchedulingBlockGuardExpression(SchedulingBlock schedulingBlock, Assignment assignment,  
        List<ControlFlow> nextFlows, Schedule schedule, SCGraph scg,  List<Node> nodeCache
    ) {
        val gExpr = schedulingBlock.createSubsequentSchedulingBlockGuardExpression(schedule, scg)
        assignment.addGuardExpression(gExpr, nextFlows, scg, nodeCache)       
    }

    
    protected def GuardExpression createSubsequentSchedulingBlockGuardExpression(SchedulingBlock schedulingBlock, Schedule schedule, SCGraph scg) {
        new GuardExpression => [
            valuedObject = schedulingBlock.guard
            expression = schedulingBlock.basicBlock.schedulingBlocks.head.guard.reference
        ]
    }
    
    /**
     * PredecessorExpression forms a single expression with respect to the predecessor,
     * meaning that the expression is a reference to the guard of the predecessor and
     * combined with the (negated) expression of a condition in the case of a 
     * conditional predecessor.
     *  
     * @param predecessor
     *          The predecessor in question.
     * @return Returns the expression for this predecessor.
     * @throws UnsupportedSCGException
     *      Throws an UnsupportedSCGException if the predecessor does not contain sufficient information to form the expression.
     */
    protected def Expression predecessorExpression(Predecessor predecessor, SchedulingBlock schedulingBlock, Schedule schedule, SCGraph scg) {
        // Return a solely reference as expression if the predecessor is not a conditional
        if (predecessor.branchType == BranchType::NORMAL) {
            return predecessor.basicBlock.schedulingBlocks.head.guard.reference
        }
        // If we are in the true branch of the predecessor, combine the predecessor guard reference with
        // the condition of the conditional and return the expression.
        else if (predecessor.branchType == BranchType::TRUEBRANCH) {
            val expression = KExpressionsFactory::eINSTANCE.createOperatorExpression
            expression.setOperator(OperatorType::AND)
            expression.subExpressions += predecessor.basicBlock.schedulingBlocks.head.guard.reference
            expression.subExpressions += predecessor.conditional.condition.copy
            
            // Conditional branches are mutual exclusive. Since the other branch may modify the condition 
            // make sure the subsequent branch will not evaluate to true if the first one was already taken.
            val twin = predecessor.getSchedulingBlockTwin(BranchType::ELSEBRANCH, schedule, scg)
            if (predecessorTwinMark.get(twin) != null) {
                expression.subExpressions.add(0, twin.guard.reference.negate)
            } 
            predecessorTwinMark.put(schedulingBlock, true)
            
            return expression.fix
        }
        // If we are in the true branch of the predecessor, combine the predecessor guard reference with
        // the negated condition of the conditional and return the expression.
        else if (predecessor.branchType == BranchType::ELSEBRANCH) {
            val expression = KExpressionsFactory::eINSTANCE.createOperatorExpression
            expression.setOperator(OperatorType::AND)
            expression.subExpressions += predecessor.basicBlock.schedulingBlocks.head.guard.reference
            expression.subExpressions += predecessor.conditional.condition.copy.negate

            // Conditional branches are mutual exclusive. Since the other branch may modify the condition 
            // make sure the subsequent branch will not evaluate to true if the first one was already taken.
            val twin = predecessor.getSchedulingBlockTwin(BranchType::TRUEBRANCH, schedule, scg)
            if (predecessorTwinMark.get(twin) != null) {
                expression.subExpressions.add(0, twin.guard.reference.negate)
            } 
            predecessorTwinMark.put(schedulingBlock, true)

            return expression.fix
        }
            
        throw new UnsupportedSCGException("Cannot create predecessor expression without predecessor block type information.")
    }
    
    protected def SchedulingBlock getSchedulingBlockTwin(Predecessor predecessor, BranchType blockType, Schedule schedule, SCGraph scg) {
//      val predecessorTwin = scg.eAllContents.filter(typeof(Predecessor)).filter[ it.getBasicBlock == predecessor.basicBlock && it.blockType == blockType].head
//      scg.eAllContents.filter(typeof(SchedulingBlock)).filter[ it.basicBlock.predecessors.contains(predecessorTwin) ].head
        val twin = predecessorTwinCache.get(predecessor)
//        twin.basicBlock.schedulingBlocks.head
        predecessorSBCache.get(twin).head
    }

    private def cacheTwin(Predecessor predecessor, List<BasicBlock> basicBlocks) {
        val bb = predecessor.basicBlock
        var predList = predecessorBBCache.get(bb)
        if (predList == null) {
            predList = <Predecessor> newArrayList => [ add(predecessor) ]
            predecessorBBCache.put(bb, predList)
        } else {
            val fPred = predList.get(0)
            predList.add(predecessor)
            predecessorTwinCache.put(fPred, predecessor)
            predecessorTwinCache.put(predecessor, fPred)
            
            
            val sbList1 = <SchedulingBlock> newArrayList
//            bb.schedulingBlocks.forEach[ sbList1 += it ]
//            sbList1 += basicBlocks.filter[ it.predecessors.contains(fPred) ].head.schedulingBlocks.head
            val basicBlock1 = fPred.eContainer as BasicBlock
            sbList1 += basicBlock1.schedulingBlocks.head
            predecessorSBCache.put(fPred, sbList1)
            
            val sbList2 = <SchedulingBlock> newArrayList
//            bb.schedulingBlocks.forEach[ sbList2 += it ]
//            sbList2 += basicBlocks.filter[ it.predecessors.contains(predecessor) ].head.schedulingBlocks.head
            val basicBlock2 = predecessor.eContainer as BasicBlock
            sbList2 += basicBlock2.schedulingBlocks.head
            predecessorSBCache.put(predecessor, sbList2)
        }
    }
    
    
}