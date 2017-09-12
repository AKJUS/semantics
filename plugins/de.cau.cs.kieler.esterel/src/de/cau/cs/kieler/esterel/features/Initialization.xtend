/*
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 *
 * http://rtsys.informatik.uni-kiel.de/kieler
 * 
 * Copyright ${year} by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License (EPL).
 */
package de.cau.cs.kieler.esterel.scest.features

import de.cau.cs.kieler.esterel.EsterelProgram
import de.cau.cs.kieler.kico.features.Feature

/**
 * @author mrb
 *
 */
class Initialization extends Feature {
    
    //-------------------------------------------------------------------------
    //--                 K I C O      C O N F I G U R A T I O N              --
    //-------------------------------------------------------------------------
    override getId() {
        return SCEstFeature::INITIALIZATION_ID
    }
    
    override getName() {
        return SCEstFeature::INITIALIZATION_NAME
    }
    
    def isContained(EsterelProgram program) {
        true
    }
}