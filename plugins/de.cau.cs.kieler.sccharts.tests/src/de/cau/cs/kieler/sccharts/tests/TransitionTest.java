/**
 * KIELER - Kiel Integrated Environment for Layout Eclipse RichClient
 * 
 * http://www.informatik.uni-kiel.de/rtsys/kieler/
 * 
 * Copyright 2013 by
 * + Kiel University
 *   + Department of Computer Science
 *     + Real-Time and Embedded Systems Group
 * 
 * This code is provided under the terms of the Eclipse Public License (EPL).
 * See the file epl-v10.html for the license text.
 */
package de.cau.cs.kieler.sccharts.tests;

import de.cau.cs.kieler.sccharts.SCChartsFactory;
import de.cau.cs.kieler.sccharts.Transition;

import junit.textui.TestRunner;

/**
 * <!-- begin-user-doc -->
 * A test case for the model object '<em><b>Transition</b></em>'.
 * <!-- end-user-doc -->
 * @generated
 */
public class TransitionTest extends ActionTest {

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public static final String copyright = "KIELER - Kiel Integrated Environment for Layout Eclipse RichClient\r\n\r\nhttp://www.informatik.uni-kiel.de/rtsys/kieler/\r\n\r\nCopyright 2013 by\r\n+ Kiel University\r\n  + Department of Computer Science\r\n    + Real-Time and Embedded Systems Group\r\n\r\nThis code is provided under the terms of the Eclipse Public License (EPL).\r\nSee the file epl-v10.html for the license text.";

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public static void main(String[] args) {
        TestRunner.run(TransitionTest.class);
    }

    /**
     * Constructs a new Transition test case with the given name.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public TransitionTest(String name) {
        super(name);
    }

    /**
     * Returns the fixture for this Transition test case.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    protected Transition getFixture() {
        return (Transition)fixture;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see junit.framework.TestCase#setUp()
     * @generated
     */
    @Override
    protected void setUp() throws Exception {
        setFixture(SCChartsFactory.eINSTANCE.createTransition());
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see junit.framework.TestCase#tearDown()
     * @generated
     */
    @Override
    protected void tearDown() throws Exception {
        setFixture(null);
    }

} //TransitionTest
