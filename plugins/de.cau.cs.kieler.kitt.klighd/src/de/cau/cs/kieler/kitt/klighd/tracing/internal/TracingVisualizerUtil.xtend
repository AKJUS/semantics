/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://www.informatik.uni-kiel.de/rtsys/kieler/
 * 
 * Copyright 2014 by
 * + Christian-Albrechts-University of Kiel
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License (EPL).
 * See the file epl-v10.html for the license text.
 */
package de.cau.cs.kieler.kitt.klighd.tracing.internal

import com.google.common.collect.HashMultimap
import com.google.common.collect.Multimap
import com.google.inject.Inject
import de.cau.cs.kieler.core.kgraph.KEdge
import de.cau.cs.kieler.core.kgraph.KGraphElement
import de.cau.cs.kieler.core.kgraph.KNode
import de.cau.cs.kieler.core.krendering.KRenderingFactory
import de.cau.cs.kieler.core.krendering.extensions.KContainerRenderingExtensions
import de.cau.cs.kieler.core.krendering.extensions.KEdgeExtensions
import de.cau.cs.kieler.core.krendering.extensions.KRenderingExtensions
import de.cau.cs.kieler.kiml.klayoutdata.KLayoutData
import de.cau.cs.kieler.kiml.options.LayoutOptions
import de.cau.cs.kieler.kitt.klighd.tracing.TracingProperties
import de.cau.cs.kieler.kitt.tracing.TracingTreeExtensions
import de.cau.cs.kieler.kitt.tracingtree.EObjectWrapper
import de.cau.cs.kieler.kitt.tracingtree.ModelWrapper
import de.cau.cs.kieler.klighd.ViewContext
import java.util.HashSet
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EObject

import static extension de.cau.cs.kieler.kitt.klighd.actions.AbstractTracingSelectionAction.*
import static extension de.cau.cs.kieler.kitt.klighd.tracing.internal.NearestNodeUtil.*
import static extension de.cau.cs.kieler.kitt.tracing.ModelTracingManager.*
import static extension de.cau.cs.kieler.klighd.util.ModelingUtil.*
import static extension de.cau.cs.kieler.klighd.syntheses.DiagramSyntheses.*
import java.util.EventObject

/**
 * @author als
 *
 */
class TracingVisualizerUtil {

    extension KRenderingFactory = KRenderingFactory.eINSTANCE

    @Inject
    extension KEdgeExtensions

    @Inject
    extension KRenderingExtensions

    @Inject
    extension KContainerRenderingExtensions

    @Inject
    extension TracingTreeExtensions

    def boolean hasTracingInformation(Object model, KNode diagram, ViewContext viewContext) {
        if (model instanceof EObject && (model as EObject).tracingActivated) {

            //If model is traced model directly
            return true;
        } else {

            //If model is a wrapper around a traced model marked as TRACED_MODEL_ROOT_NODE
            return diagram.eAllContentsOfType2(typeof(KNode)).filter [
                (it as KNode).getData(KLayoutData)?.getProperty(TracingProperties.TRACED_MODEL_ROOT_NODE)
            ].findFirst[viewContext.getSourceElement(it).tracingActivated] != null;
        }
    }

    def clearTracing(KNode diagram) {
        diagram.clearTracingSelection;

        //Hide all edges marked as TRACING_EDGE
        diagram.eAllContentsOfType2(typeof(KNode)).forEach [
            (it as KNode).outgoingEdges.filter [
                it.tracingEdge;
            ].toList.forEach [
                it.KRendering.invisible = true;
            ]
        ]
    }

    def traceAll(KNode diagram, ViewContext viewContext, boolean forceReTrace) {
        diagram.showTracingSelection;

        //check for existing tracing edge
        val hasTracingEdges = diagram.eAllContentsOfType2(typeof(KNode)).findFirst [
            (it as KNode).outgoingEdges.findFirst [
                it.tracingEdge;
            ] != null;
        ] != null;

        //add tracing edges if necessary
        if (!hasTracingEdges || forceReTrace) {
            diagram.addAllTracingEdges(viewContext);
        }

        //Show all edges marked as TRACING_EDGE
        diagram.eAllContentsOfType2(typeof(KNode)).forEach [
            (it as KNode).outgoingEdges.filter [
                it.tracingEdge;
            ].toList.forEach [
                it.KRendering.invisible = false;
            ]
        ];
    }

    def traceElements(KNode diagram, ViewContext viewContext, List<EObject> selection, boolean forceReTrace) {
        diagram.showTracingSelection;

        //check for existing tracing edge
        val hasTracingEdges = diagram.eAllContentsOfType2(typeof(KNode)).findFirst [
            (it as KNode).outgoingEdges.findFirst [
                it.tracingEdge;
            ] != null;
        ] != null;

        //add tracing edges if necessary
        if (!hasTracingEdges || forceReTrace) {
            diagram.addAllTracingEdges(viewContext);
        }

        //Show selected edges marked as TRACING_EDGE
        val HashSet<Object> visibleEdgesModelOrigin = newHashSet(); //Set of all origins of tracing edges which are selected or related to these
        if (selection != null && !selection.empty) {
            val selectedSourceElements = selection.map[viewContext.getSourceElement(it)].filterNull;
            if (viewContext.inputModel instanceof ModelWrapper) { //In case of displaying a TracingTree
                selectedSourceElements.forEach [
                    if (it instanceof EObjectWrapper) {

                        //add tracing children
                        val children = new GenericTreeIterator(it, true,
                            [
                                val elem = it as EObjectWrapper;
                                if (!elem.model.targetTransformations.empty) {
                                    elem.children(elem.model.targetTransformations.get(0)).iterator
                                } else {
                                    emptyList.iterator;
                                }
                            ]).toIterable.toList;
                        visibleEdgesModelOrigin.addAll(children);

                        //add tracing parents
                        val parents = new GenericTreeIterator(it, false,
                            [
                                val elem = it as EObjectWrapper;
                                if (elem.model.sourceTransformation != null) {
                                    elem.parents(elem.model.sourceTransformation).iterator
                                } else {
                                    emptyList.iterator;
                                }
                            ]).toIterable.toList;
                        visibleEdgesModelOrigin.addAll(parents);

                        //add real object if tracing tree is not transient
                        if (!it.model.transient) {
                            visibleEdgesModelOrigin.addAll(parents.map[it.EObject].filterNull);
                        }
                    } else {
                        visibleEdgesModelOrigin.add(it);
                    }
                ]
            } else {
                val mapping = viewContext.getProperty(TracingProperties.TRACING_MAP);
                if (mapping != null) {
                    val selectedSourceElementsList = selectedSourceElements.filter[it instanceof EObject].map[
                        it as EObject].toList;
                    var children = selectedSourceElementsList;
                    while (!children.empty && visibleEdgesModelOrigin.addAll(children)) {
                        children = children.fold(newLinkedList) [ list, item |
                            list.addAll(mapping.get(item));
                            list;
                        ];
                    }
                    var parents = selectedSourceElementsList;
                    while (!parents.empty && visibleEdgesModelOrigin.addAll(parents)) {
                        parents = parents.fold(newLinkedList) [ list, item |
                            list.addAll(mapping.getReverse(item));
                            list;
                        ];
                    }
                }
            }
        }

        //iterate over all tracing edges and show all edges originated from selected model elements, all others invisible
        diagram.eAllContentsOfType2(typeof(KNode)).forEach [
            (it as KNode).outgoingEdges.filter [
                it.tracingEdge;
            ].toList.forEach [
                if (visibleEdgesModelOrigin.empty) {
                    it.KRendering.invisible = true;
                } else {
                    val origin = it.getData(KLayoutData).getProperty(TracingProperties.TRACING_EDGE);
                    it.KRendering.invisible = !(visibleEdgesModelOrigin.contains(origin.key) &&
                        visibleEdgesModelOrigin.contains(origin.value));
                }
            ]
        ];
    }

    private def addAllTracingEdges(KNode diagram, ViewContext viewContext) {

        //Remove all edges marked as TRACING_EDGE
        diagram.eAllContentsOfType2(typeof(KNode)).forEach [
            (it as KNode).outgoingEdges.filter [
                it.tracingEdge;
            ].toList.forEach [
                it.source = null;
                it.target = null;
            ]
        ];

        //Add tracing edges
        if (viewContext.inputModel instanceof ModelWrapper) { //Tracing Tree
            val tree = viewContext.inputModel as ModelWrapper;
            val selection = diagram.getTracingSelection(viewContext);
            if (selection != null) { //resolve mapping if source target are selected
                addTracingTreeEdges(selection.key as ModelWrapper, selection.value as ModelWrapper, viewContext);
            } else { //dont resolve -> show all
                tree.succeedingTransformations.forEach [
                    addTracingTreeEdges(it.source, it.target, viewContext);
                ];
            }
        } else { //Other models

            //get all traced models contained in this model
            val tracedModels = diagram.eAllContentsOfType2(typeof(KNode)).filter [
                (it as KNode).getData(KLayoutData).getProperty(TracingProperties.TRACED_MODEL_ROOT_NODE);
            ].map[viewContext.getSourceElement(it)].filterNull.filter[it.tracingActivated].toList;

            if (!tracedModels.empty) {
                val traceMap = new InternalTraceMap();
                val selection = diagram.getTracingSelection(viewContext);
                if (selection != null) { //resolve mapping if source target are selected
                    val mapping = getMapping(selection.key, selection.value)
                    mapping.addTracingEdges(viewContext);
                    traceMap.addMapping(mapping);
                } else { //dont resolve -> show all
                    val chain = (tracedModels.head as EObject).tracingChain;
                    if (!chain.empty) {

                        //Iterate over all step in the chain apply mappings
                        val chainIter = chain.listIterator;
                        var item = chainIter.next;
                        while (chainIter.hasNext) {
                            var next = chainIter.next;
                            if (tracedModels.contains(item.key)) {
                                if (tracedModels.contains(next.key)) {

                                    //create edges
                                    item.value.addTracingEdges(viewContext);
                                    traceMap.addMapping(item.value);
                                }
                            } else { //if a model in the chain is not represented in the diagram skip it and resolve to next represented one
                                var loop = true;
                                while (loop || chainIter.hasNext) {
                                    next = chainIter.next;
                                    if (tracedModels.contains(next.key)) {

                                        //create edges
                                        val mapping = getMapping(item.key, next.key)
                                        mapping.addTracingEdges(viewContext);
                                        traceMap.addMapping(mapping);

                                        //end this loop
                                        loop = false;
                                    }
                                }
                            }
                            item = next;
                        }
                    }
                }
                viewContext.setProperty(TracingProperties.TRACING_MAP, traceMap);
            }
        }
    }

    private def addTracingEdges(Multimap<EObject, EObject> mapping, ViewContext viewContext) {
        if (mapping != null && !mapping.empty) {
            mapping.entries.forEach [ entry |
                viewContext.getTargetElements(entry.key).forEach [ source |
                    viewContext.getTargetElements(entry.value).forEach [ target |
                        createTracingEdge(source, target, new Pair(entry.key, entry.value));
                    ]
                ]
            ]
        }
    }

    private def addTracingTreeEdges(ModelWrapper source, ModelWrapper target, ViewContext viewContext) {
        if (source != null && target != null) {
            val mapping = source.joinWrapperMappings(target);
            var Map<EObjectWrapper, EObject> _sourceInstanceMap = null;
            var Map<EObjectWrapper, EObject> _targetInstanceMap = null;
            if (!source.transient && viewContext.getTargetElements(source).findFirst[
                it instanceof KGraphElement &&
                    (it as KGraphElement).getData(KLayoutData).getProperty(TracingProperties.TRACED_MODEL_ROOT_NODE)] !=
                null) {
                _sourceInstanceMap = source.modelInstanceMapping(source.rootObject.EObject);
            }
            if (!target.transient && viewContext.getTargetElements(target).findFirst[
                it instanceof KGraphElement &&
                    (it as KGraphElement).getData(KLayoutData).getProperty(TracingProperties.TRACED_MODEL_ROOT_NODE)] !=
                null) {
                _targetInstanceMap = target.modelInstanceMapping(target.rootObject.EObject);
            }
            val sourceInstanceMap = _sourceInstanceMap;
            val targetInstanceMap = _targetInstanceMap;
            if (mapping != null && !mapping.empty) {
                mapping.entries.forEach [ entry |
                    val key = if (sourceInstanceMap != null) {
                            sourceInstanceMap.get(entry.key);
                        } else {
                            entry.key;
                        }
                    val value = if (targetInstanceMap != null) {
                            targetInstanceMap.get(entry.value);
                        } else {
                            entry.value;
                        }
                    viewContext.getTargetElements(key).forEach [ elementSource |
                        viewContext.getTargetElements(value).forEach [ elementTarget |
                            createTracingEdge(elementSource, elementTarget, new Pair(key, value));
                        ]
                    ]
                ]
            }
        }
    }

    private def createTracingEdge(EObject source, EObject target, Pair<Object, Object> origin) {
        if (source != null && target != null && origin != null) {
            val sourceNode = source.nearestNode;
            val targetNode = target.nearestNode;
            if (sourceNode != null && targetNode != null) {
                createEdge => [
                    it.source = sourceNode;
                    it.target = targetNode;
                    it.getData(KLayoutData).setProperty(LayoutOptions.NO_LAYOUT, true);
                    it.getData(KLayoutData).setProperty(TracingProperties.TRACING_EDGE, origin);
                    it.addPolyline => [
                        it.invisible = true;
                        it.invisible.propagateToChildren = true;
                    ];
                //            edge.data += createKCustomRendering => [
                //                it.invisible = true;
                //                it.invisible.propagateToChildren = true;
                //                it.figureObject = new TracingEdgeNode();
                //                //it.addPolyline;
                //                it.setLineWidth(5f)
                //            //            it.setProperty(SOURCE_ELEMENT, kge);
                //            //            it.setProperty(TARGET_ELEMENT, kge);
                //            ];
                ]
            }
        }
    }

    private def isTracingEdge(KEdge edge) {
        return edge.getData(KLayoutData)?.getProperty(TracingProperties.TRACING_EDGE) != null;
    }
}
