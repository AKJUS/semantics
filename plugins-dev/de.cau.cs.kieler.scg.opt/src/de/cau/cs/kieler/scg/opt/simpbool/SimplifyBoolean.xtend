package de.cau.cs.kieler.scg.opt.simpbool

import de.cau.cs.kieler.kico.transformation.AbstractProductionTransformation
import de.cau.cs.kieler.scg.opt.features.OptimizerFeatures
import de.cau.cs.kieler.scg.SCGraph
import de.cau.cs.kieler.scg.features.SCGFeatures
import de.cau.cs.kieler.scg.features.SCGFeatureGroups

class SimplifyBoolean extends AbstractProductionTransformation {
    private static final val DEBUG = false
    private static final val INSTRUMENTED = true

    override getProducedFeatureId() {
        return OptimizerFeatures::BL_ID
    }

    override getRequiredFeatureIds() {
        return newHashSet(SCGFeatures::SEQUENTIALIZE_ID, SCGFeatureGroups::SCG_ID /*OptimizerFeatures::CP_ID*/ )
    }

    override getId() {
        return OptimizerFeatures::BL_ID
    }

    override getName() {
        return OptimizerFeatures::BL_NAME
    }

    def SCGraph transform(SCGraph scg) {
        return scg
    }
}