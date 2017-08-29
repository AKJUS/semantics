/**
 */
package de.cau.cs.kieler.esterel.esterel;

import de.cau.cs.kieler.kexpressions.Expression;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Delay Expr</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.esterel.esterel.DelayExpr#getExpression <em>Expression</em>}</li>
 *   <li>{@link de.cau.cs.kieler.esterel.esterel.DelayExpr#isIsImmediate <em>Is Immediate</em>}</li>
 *   <li>{@link de.cau.cs.kieler.esterel.esterel.DelayExpr#getSignalExpr <em>Signal Expr</em>}</li>
 * </ul>
 *
 * @see de.cau.cs.kieler.esterel.esterel.EsterelPackage#getDelayExpr()
 * @model
 * @generated
 */
public interface DelayExpr extends EObject {
    /**
     * Returns the value of the '<em><b>Expression</b></em>' containment reference.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Expression</em>' containment reference isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Expression</em>' containment reference.
     * @see #setExpression(Expression)
     * @see de.cau.cs.kieler.esterel.esterel.EsterelPackage#getDelayExpr_Expression()
     * @model containment="true"
     * @generated
     */
    Expression getExpression();

    /**
     * Sets the value of the '{@link de.cau.cs.kieler.esterel.esterel.DelayExpr#getExpression <em>Expression</em>}' containment reference.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @param value the new value of the '<em>Expression</em>' containment reference.
     * @see #getExpression()
     * @generated
     */
    void setExpression(Expression value);

    /**
     * Returns the value of the '<em><b>Is Immediate</b></em>' attribute.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Is Immediate</em>' attribute isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Is Immediate</em>' attribute.
     * @see #setIsImmediate(boolean)
     * @see de.cau.cs.kieler.esterel.esterel.EsterelPackage#getDelayExpr_IsImmediate()
     * @model
     * @generated
     */
    boolean isIsImmediate();

    /**
     * Sets the value of the '{@link de.cau.cs.kieler.esterel.esterel.DelayExpr#isIsImmediate <em>Is Immediate</em>}' attribute.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @param value the new value of the '<em>Is Immediate</em>' attribute.
     * @see #isIsImmediate()
     * @generated
     */
    void setIsImmediate(boolean value);

    /**
     * Returns the value of the '<em><b>Signal Expr</b></em>' containment reference.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Signal Expr</em>' containment reference isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Signal Expr</em>' containment reference.
     * @see #setSignalExpr(Expression)
     * @see de.cau.cs.kieler.esterel.esterel.EsterelPackage#getDelayExpr_SignalExpr()
     * @model containment="true"
     * @generated
     */
    Expression getSignalExpr();

    /**
     * Sets the value of the '{@link de.cau.cs.kieler.esterel.esterel.DelayExpr#getSignalExpr <em>Signal Expr</em>}' containment reference.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @param value the new value of the '<em>Signal Expr</em>' containment reference.
     * @see #getSignalExpr()
     * @generated
     */
    void setSignalExpr(Expression value);

} // DelayExpr
