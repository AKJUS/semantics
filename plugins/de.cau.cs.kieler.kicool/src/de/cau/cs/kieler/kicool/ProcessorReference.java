/**
 */
package de.cau.cs.kieler.kicool;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Processor Reference</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.kicool.ProcessorReference#getPresets <em>Presets</em>}</li>
 *   <li>{@link de.cau.cs.kieler.kicool.ProcessorReference#getPostsets <em>Postsets</em>}</li>
 *   <li>{@link de.cau.cs.kieler.kicool.ProcessorReference#getMetric <em>Metric</em>}</li>
 *   <li>{@link de.cau.cs.kieler.kicool.ProcessorReference#getPreprocesses <em>Preprocesses</em>}</li>
 *   <li>{@link de.cau.cs.kieler.kicool.ProcessorReference#getPostprocesses <em>Postprocesses</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.kieler.kicool.KiCoolPackage#getProcessorReference()
 * @model
 * @generated
 */
public interface ProcessorReference extends ProcessorEntry {
    /**
     * Returns the value of the '<em><b>Presets</b></em>' containment reference list.
     * The list contents are of type {@link de.cau.cs.kieler.kicool.KVPair}.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Presets</em>' containment reference list isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Presets</em>' containment reference list.
     * @see de.cau.cs.kieler.kicool.KiCoolPackage#getProcessorReference_Presets()
     * @model containment="true"
     * @generated
     */
    EList<KVPair> getPresets();

    /**
     * Returns the value of the '<em><b>Postsets</b></em>' containment reference list.
     * The list contents are of type {@link de.cau.cs.kieler.kicool.KVPair}.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Postsets</em>' containment reference list isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Postsets</em>' containment reference list.
     * @see de.cau.cs.kieler.kicool.KiCoolPackage#getProcessorReference_Postsets()
     * @model containment="true"
     * @generated
     */
    EList<KVPair> getPostsets();

    /**
     * Returns the value of the '<em><b>Metric</b></em>' reference.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Metric</em>' reference isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Metric</em>' reference.
     * @see #setMetric(IntermediateReference)
     * @see de.cau.cs.kieler.kicool.KiCoolPackage#getProcessorReference_Metric()
     * @model
     * @generated
     */
    IntermediateReference getMetric();

    /**
     * Sets the value of the '{@link de.cau.cs.kieler.kicool.ProcessorReference#getMetric <em>Metric</em>}' reference.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @param value the new value of the '<em>Metric</em>' reference.
     * @see #getMetric()
     * @generated
     */
    void setMetric(IntermediateReference value);

    /**
     * Returns the value of the '<em><b>Preprocesses</b></em>' containment reference list.
     * The list contents are of type {@link de.cau.cs.kieler.kicool.ProcessorReference}.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Preprocesses</em>' containment reference list isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Preprocesses</em>' containment reference list.
     * @see de.cau.cs.kieler.kicool.KiCoolPackage#getProcessorReference_Preprocesses()
     * @model containment="true"
     * @generated
     */
    EList<ProcessorReference> getPreprocesses();

    /**
     * Returns the value of the '<em><b>Postprocesses</b></em>' containment reference list.
     * The list contents are of type {@link de.cau.cs.kieler.kicool.ProcessorReference}.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Postprocesses</em>' containment reference list isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Postprocesses</em>' containment reference list.
     * @see de.cau.cs.kieler.kicool.KiCoolPackage#getProcessorReference_Postprocesses()
     * @model containment="true"
     * @generated
     */
    EList<ProcessorReference> getPostprocesses();

} // ProcessorReference
