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

import de.cau.cs.kieler.kico.features.Feature
import de.cau.cs.kieler.esterel.scest.SCEstProgram

/**
 * @author mrb
 *
 */
class SignalFeature extends Feature {
    
    //-------------------------------------------------------------------------
    //--                 K I C O      C O N F I G U R A T I O N              --
    //-------------------------------------------------------------------------
    override getId() {
        return SCEstFeature::SIGNAL_ID
    }
    
    override getName() {
        return SCEstFeature::SIGNAL_NAME
    }
    
    def isContained(SCEstProgram program) {
        true
    }
    
}