/**
 */
package de.cau.cs.kieler.esterel.impl;

import de.cau.cs.kieler.annotations.Annotation;

import de.cau.cs.kieler.esterel.ElsIf;
import de.cau.cs.kieler.esterel.EsterelPackage;
import de.cau.cs.kieler.esterel.IfTest;

import de.cau.cs.kieler.kexpressions.Expression;

import de.cau.cs.kieler.scl.Statement;

import de.cau.cs.kieler.scl.impl.StatementImpl;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>If Test</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link de.cau.cs.kieler.esterel.impl.IfTestImpl#getExpression <em>Expression</em>}</li>
 *   <li>{@link de.cau.cs.kieler.esterel.impl.IfTestImpl#getThenAnnotations <em>Then Annotations</em>}</li>
 *   <li>{@link de.cau.cs.kieler.esterel.impl.IfTestImpl#getThenStatements <em>Then Statements</em>}</li>
 *   <li>{@link de.cau.cs.kieler.esterel.impl.IfTestImpl#getElseif <em>Elseif</em>}</li>
 *   <li>{@link de.cau.cs.kieler.esterel.impl.IfTestImpl#getElseAnnotations <em>Else Annotations</em>}</li>
 *   <li>{@link de.cau.cs.kieler.esterel.impl.IfTestImpl#getElseStatements <em>Else Statements</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IfTestImpl extends StatementImpl implements IfTest
{
  /**
   * The cached value of the '{@link #getExpression() <em>Expression</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getExpression()
   * @generated
   * @ordered
   */
  protected Expression expression;

  /**
   * The cached value of the '{@link #getThenAnnotations() <em>Then Annotations</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getThenAnnotations()
   * @generated
   * @ordered
   */
  protected EList<Annotation> thenAnnotations;

  /**
   * The cached value of the '{@link #getThenStatements() <em>Then Statements</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getThenStatements()
   * @generated
   * @ordered
   */
  protected EList<Statement> thenStatements;

  /**
   * The cached value of the '{@link #getElseif() <em>Elseif</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getElseif()
   * @generated
   * @ordered
   */
  protected EList<ElsIf> elseif;

  /**
   * The cached value of the '{@link #getElseAnnotations() <em>Else Annotations</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getElseAnnotations()
   * @generated
   * @ordered
   */
  protected EList<Annotation> elseAnnotations;

  /**
   * The cached value of the '{@link #getElseStatements() <em>Else Statements</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getElseStatements()
   * @generated
   * @ordered
   */
  protected EList<Statement> elseStatements;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected IfTestImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  protected EClass eStaticClass()
  {
    return EsterelPackage.Literals.IF_TEST;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Expression getExpression()
  {
    return expression;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public NotificationChain basicSetExpression(Expression newExpression, NotificationChain msgs)
  {
    Expression oldExpression = expression;
    expression = newExpression;
    if (eNotificationRequired())
    {
      ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, EsterelPackage.IF_TEST__EXPRESSION, oldExpression, newExpression);
      if (msgs == null) msgs = notification; else msgs.add(notification);
    }
    return msgs;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setExpression(Expression newExpression)
  {
    if (newExpression != expression)
    {
      NotificationChain msgs = null;
      if (expression != null)
        msgs = ((InternalEObject)expression).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - EsterelPackage.IF_TEST__EXPRESSION, null, msgs);
      if (newExpression != null)
        msgs = ((InternalEObject)newExpression).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - EsterelPackage.IF_TEST__EXPRESSION, null, msgs);
      msgs = basicSetExpression(newExpression, msgs);
      if (msgs != null) msgs.dispatch();
    }
    else if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, EsterelPackage.IF_TEST__EXPRESSION, newExpression, newExpression));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<Annotation> getThenAnnotations()
  {
    if (thenAnnotations == null)
    {
      thenAnnotations = new EObjectContainmentEList<Annotation>(Annotation.class, this, EsterelPackage.IF_TEST__THEN_ANNOTATIONS);
    }
    return thenAnnotations;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<Statement> getThenStatements()
  {
    if (thenStatements == null)
    {
      thenStatements = new EObjectContainmentEList<Statement>(Statement.class, this, EsterelPackage.IF_TEST__THEN_STATEMENTS);
    }
    return thenStatements;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<ElsIf> getElseif()
  {
    if (elseif == null)
    {
      elseif = new EObjectContainmentEList<ElsIf>(ElsIf.class, this, EsterelPackage.IF_TEST__ELSEIF);
    }
    return elseif;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<Annotation> getElseAnnotations()
  {
    if (elseAnnotations == null)
    {
      elseAnnotations = new EObjectContainmentEList<Annotation>(Annotation.class, this, EsterelPackage.IF_TEST__ELSE_ANNOTATIONS);
    }
    return elseAnnotations;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<Statement> getElseStatements()
  {
    if (elseStatements == null)
    {
      elseStatements = new EObjectContainmentEList<Statement>(Statement.class, this, EsterelPackage.IF_TEST__ELSE_STATEMENTS);
    }
    return elseStatements;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs)
  {
    switch (featureID)
    {
      case EsterelPackage.IF_TEST__EXPRESSION:
        return basicSetExpression(null, msgs);
      case EsterelPackage.IF_TEST__THEN_ANNOTATIONS:
        return ((InternalEList<?>)getThenAnnotations()).basicRemove(otherEnd, msgs);
      case EsterelPackage.IF_TEST__THEN_STATEMENTS:
        return ((InternalEList<?>)getThenStatements()).basicRemove(otherEnd, msgs);
      case EsterelPackage.IF_TEST__ELSEIF:
        return ((InternalEList<?>)getElseif()).basicRemove(otherEnd, msgs);
      case EsterelPackage.IF_TEST__ELSE_ANNOTATIONS:
        return ((InternalEList<?>)getElseAnnotations()).basicRemove(otherEnd, msgs);
      case EsterelPackage.IF_TEST__ELSE_STATEMENTS:
        return ((InternalEList<?>)getElseStatements()).basicRemove(otherEnd, msgs);
    }
    return super.eInverseRemove(otherEnd, featureID, msgs);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Object eGet(int featureID, boolean resolve, boolean coreType)
  {
    switch (featureID)
    {
      case EsterelPackage.IF_TEST__EXPRESSION:
        return getExpression();
      case EsterelPackage.IF_TEST__THEN_ANNOTATIONS:
        return getThenAnnotations();
      case EsterelPackage.IF_TEST__THEN_STATEMENTS:
        return getThenStatements();
      case EsterelPackage.IF_TEST__ELSEIF:
        return getElseif();
      case EsterelPackage.IF_TEST__ELSE_ANNOTATIONS:
        return getElseAnnotations();
      case EsterelPackage.IF_TEST__ELSE_STATEMENTS:
        return getElseStatements();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @SuppressWarnings("unchecked")
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case EsterelPackage.IF_TEST__EXPRESSION:
        setExpression((Expression)newValue);
        return;
      case EsterelPackage.IF_TEST__THEN_ANNOTATIONS:
        getThenAnnotations().clear();
        getThenAnnotations().addAll((Collection<? extends Annotation>)newValue);
        return;
      case EsterelPackage.IF_TEST__THEN_STATEMENTS:
        getThenStatements().clear();
        getThenStatements().addAll((Collection<? extends Statement>)newValue);
        return;
      case EsterelPackage.IF_TEST__ELSEIF:
        getElseif().clear();
        getElseif().addAll((Collection<? extends ElsIf>)newValue);
        return;
      case EsterelPackage.IF_TEST__ELSE_ANNOTATIONS:
        getElseAnnotations().clear();
        getElseAnnotations().addAll((Collection<? extends Annotation>)newValue);
        return;
      case EsterelPackage.IF_TEST__ELSE_STATEMENTS:
        getElseStatements().clear();
        getElseStatements().addAll((Collection<? extends Statement>)newValue);
        return;
    }
    super.eSet(featureID, newValue);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eUnset(int featureID)
  {
    switch (featureID)
    {
      case EsterelPackage.IF_TEST__EXPRESSION:
        setExpression((Expression)null);
        return;
      case EsterelPackage.IF_TEST__THEN_ANNOTATIONS:
        getThenAnnotations().clear();
        return;
      case EsterelPackage.IF_TEST__THEN_STATEMENTS:
        getThenStatements().clear();
        return;
      case EsterelPackage.IF_TEST__ELSEIF:
        getElseif().clear();
        return;
      case EsterelPackage.IF_TEST__ELSE_ANNOTATIONS:
        getElseAnnotations().clear();
        return;
      case EsterelPackage.IF_TEST__ELSE_STATEMENTS:
        getElseStatements().clear();
        return;
    }
    super.eUnset(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public boolean eIsSet(int featureID)
  {
    switch (featureID)
    {
      case EsterelPackage.IF_TEST__EXPRESSION:
        return expression != null;
      case EsterelPackage.IF_TEST__THEN_ANNOTATIONS:
        return thenAnnotations != null && !thenAnnotations.isEmpty();
      case EsterelPackage.IF_TEST__THEN_STATEMENTS:
        return thenStatements != null && !thenStatements.isEmpty();
      case EsterelPackage.IF_TEST__ELSEIF:
        return elseif != null && !elseif.isEmpty();
      case EsterelPackage.IF_TEST__ELSE_ANNOTATIONS:
        return elseAnnotations != null && !elseAnnotations.isEmpty();
      case EsterelPackage.IF_TEST__ELSE_STATEMENTS:
        return elseStatements != null && !elseStatements.isEmpty();
    }
    return super.eIsSet(featureID);
  }

} //IfTestImpl
