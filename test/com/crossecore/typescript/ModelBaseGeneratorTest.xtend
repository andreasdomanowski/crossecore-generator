package com.crossecore.typescript

import antlr.typescript.TypeScriptLexer
import antlr.typescript.TypeScriptParser
import com.crossecore.TreeUtils
import java.util.Arrays
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.tree.xpath.XPath
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.emf.ecore.util.Diagnostician
import org.junit.Before
import org.junit.Test

class ModelBaseGeneratorTest {

	private EPackage epackage
	private static String PIVOT = "http://www.eclipse.org/emf/2002/Ecore/OCL/Pivot"

	@Before def void setup(){
		
		epackage = EcoreFactory.eINSTANCE.createEPackage()
		epackage.name = "MyPackage"
		epackage.nsURI = "com.mypackage"
		epackage.nsPrefix = "mypackage"
		
		val class_supertype = EcoreFactory.eINSTANCE.createEClass();
		class_supertype.name = "SuperType"
		epackage.EClassifiers.add(class_supertype)
		
		val class_indirect_supertype = EcoreFactory.eINSTANCE.createEClass();
		class_indirect_supertype.name = "IndirectSuperType"
		epackage.EClassifiers.add(class_indirect_supertype)
		
		val class_interface = EcoreFactory.eINSTANCE.createEClass();
		class_interface.name = "SuperInterface"
		epackage.EClassifiers.add(class_interface)
		
		val eenum = EcoreFactory.eINSTANCE.createEEnum();
		eenum.name = "MyEnum"
		val literal = EcoreFactory.eINSTANCE.createEEnumLiteral();
		literal.name = "EINS"
		literal.value = 1
		eenum.ELiterals.add(literal)
		epackage.EClassifiers.add(eenum)

		val classa = EcoreFactory.eINSTANCE.createEClass();
		classa.name = "ClassA"
		classa.ESuperTypes.add(class_supertype)
		classa.ESuperTypes.add(class_indirect_supertype)
		classa.ESuperTypes.add(class_interface)
		
		val eannotation5 = EcoreFactory.eINSTANCE.createEAnnotation()
		eannotation5.source = PIVOT
		eannotation5.details.put("invariant", "true")
		classa.EAnnotations.add(eannotation5)
		epackage.EClassifiers.add(classa)
		
		val classb = EcoreFactory.eINSTANCE.createEClass();
		classb.name = "referencedType"
		epackage.EClassifiers.add(classb)
		
		val classb_classa_single = EcoreFactory.eINSTANCE.createEReference()
		classb_classa_single.name = "myclass_single"
		classb_classa_single.EType = classa
		classb.EStructuralFeatures.add(classb_classa_single)
		
		val classb_classa_many = EcoreFactory.eINSTANCE.createEReference()
		classb_classa_many.name = "myclass_many"
		classb_classa_many.EType = classa
		classb_classa_many.upperBound = -1
		classb.EStructuralFeatures.add(classb_classa_many)
		
		val classindirectsupertype_attribute = EcoreFactory.eINSTANCE.createEAttribute()
		classindirectsupertype_attribute.name = "super_attribute"
		classindirectsupertype_attribute.EType = EcorePackage.Literals.ESTRING
		class_indirect_supertype.EStructuralFeatures.add(classindirectsupertype_attribute)
		
		val classa_attribute = EcoreFactory.eINSTANCE.createEAttribute()
		classa_attribute.name = "attribute"
		classa_attribute.EType = EcorePackage.Literals.ESTRING
		classa.EStructuralFeatures.add(classa_attribute)
		
		val classa_derivedattribute = EcoreFactory.eINSTANCE.createEAttribute()
		classa_derivedattribute.name = "derivedAttributeSingle"
		classa_derivedattribute.derived = true
		classa_derivedattribute.EType = EcorePackage.Literals.ESTRING
		classa.EStructuralFeatures.add(classa_derivedattribute)

		val classa_derivedoclattribute = EcoreFactory.eINSTANCE.createEAttribute()
		classa_derivedoclattribute.name = "derivedOclAttributeSingle"
		classa_derivedoclattribute.derived = true
		classa_derivedoclattribute.EType = EcorePackage.Literals.ESTRING
		val eannotation = EcoreFactory.eINSTANCE.createEAnnotation()
		eannotation.source = PIVOT
		eannotation.details.put("derivation", "'hi'")
		classa_derivedoclattribute.EAnnotations.add(eannotation)
		classa.EStructuralFeatures.add(classa_derivedoclattribute)
		
		val classa_derivedattributeMany = EcoreFactory.eINSTANCE.createEAttribute()
		classa_derivedattributeMany.name = "derivedAttributeMany"
		classa_derivedattributeMany.derived = true
		classa_derivedattributeMany.EType = EcorePackage.Literals.ESTRING
		classa.EStructuralFeatures.add(classa_derivedattributeMany)
		
		val classa_attribute_many = EcoreFactory.eINSTANCE.createEAttribute()
		classa_attribute_many.name = "attribute_many"
		classa_attribute_many.EType = EcorePackage.Literals.ESTRING
		classa_attribute_many.upperBound = -1
		classa.EStructuralFeatures.add(classa_attribute_many)
		
		val classa_classb_derivedSingle = EcoreFactory.eINSTANCE.createEReference()
		classa_classb_derivedSingle.name = "classBderivedSingle"
		classa_classb_derivedSingle.EType = classb
		classa_classb_derivedSingle.derived = true
		classa.EStructuralFeatures.add(classa_classb_derivedSingle)
		
		val classa_classb_derivedocl = EcoreFactory.eINSTANCE.createEReference()
		classa_classb_derivedocl.name = "derivedOclReferenceSingle"
		classa_classb_derivedocl.derived = true
		classa_classb_derivedocl.EType = EcorePackage.Literals.ESTRING
		val eannotation2 = EcoreFactory.eINSTANCE.createEAnnotation()
		eannotation2.source = PIVOT
		eannotation2.details.put("derivation", "null")
		classa_classb_derivedocl.EAnnotations.add(eannotation2)
		classa.EStructuralFeatures.add(classa_classb_derivedocl)
		
		val classa_classb_derivedMany = EcoreFactory.eINSTANCE.createEReference()
		classa_classb_derivedMany.name = "classBderivedMany"
		classa_classb_derivedMany.EType = classb
		classa_classb_derivedMany.upperBound = -1
		classa_classb_derivedMany.derived = true
		classa.EStructuralFeatures.add(classa_classb_derivedMany)
		
		val classa_classb_derivedocl_many = EcoreFactory.eINSTANCE.createEReference()
		classa_classb_derivedocl_many.name = "derivedOclReferenceMany"
		classa_classb_derivedocl_many.derived = true
		classa_classb_derivedocl_many.ordered = true
		classa_classb_derivedocl_many.unique = true
		classa_classb_derivedocl_many.EType = EcorePackage.Literals.ESTRING
		val eannotation3= EcoreFactory.eINSTANCE.createEAnnotation()
		eannotation3.source = PIVOT
		eannotation3.details.put("derivation", "OrderedSet{}")
		classa_classb_derivedocl_many.EAnnotations.add(eannotation3)
		classa.EStructuralFeatures.add(classa_classb_derivedocl_many)	
		
		val classa_classb_single = EcoreFactory.eINSTANCE.createEReference()
		classa_classb_single.name = "referencedType"
		classa_classb_single.EType = classb
		classa_classb_single.EOpposite = classb_classa_single
		classa.EStructuralFeatures.add(classa_classb_single)
		
		val classa_classb_many = EcoreFactory.eINSTANCE.createEReference()
		classa_classb_many.name = "containment"
		classa_classb_many.EType = classb
		classa_classb_many.containment = true
		classa_classb_many.upperBound = -1
		classa_classb_many.EOpposite = classb_classa_many
		classa.EStructuralFeatures.add(classa_classb_many)	
		
		val ereference_map = EcoreFactory.eINSTANCE.createEReference()
		ereference_map.name = "referenceMap"
		ereference_map.EType = EcorePackage.Literals.ESTRING_TO_STRING_MAP_ENTRY
		ereference_map.upperBound = -1
		ereference_map.containment = true
		classa.EStructuralFeatures.add(ereference_map)
			
				
		val classa_operation = EcoreFactory.eINSTANCE.createEOperation()
		classa_operation.name = "operation_overload"
		classa.EOperations.add(classa_operation)
		
		val classa_operation_param1 = EcoreFactory.eINSTANCE.createEParameter()
		classa_operation_param1.name = "p1"
		classa_operation_param1.EType = EcorePackage.Literals.ESTRING
		classa_operation.EParameters.add(classa_operation_param1)
		
		val classa_operation2 = EcoreFactory.eINSTANCE.createEOperation()
		classa_operation2.name = "operation_overload"
		classa_operation2.EType = EcorePackage.Literals.ESTRING
		classa.EOperations.add(classa_operation2)

		val classa_operation2_param1 = EcoreFactory.eINSTANCE.createEParameter()
		classa_operation2_param1.name = "p1"
		classa_operation2_param1.EType = EcorePackage.Literals.EINT
		classa_operation2.EParameters.add(classa_operation2_param1)
		
		val classa_operation3 = EcoreFactory.eINSTANCE.createEOperation()
		classa_operation3.name = "operation"
		classa_operation3.EType = EcorePackage.Literals.ESTRING
		classa.EOperations.add(classa_operation3)
		
		val classa_operation4 = EcoreFactory.eINSTANCE.createEOperation()
		classa_operation4.name = "operationocl"
		classa_operation4.EType = EcorePackage.Literals.ESTRING
		
		val eannotation4 = EcoreFactory.eINSTANCE.createEAnnotation()
		eannotation4.source = PIVOT
		eannotation4.details.put("body", "'hi'")
		classa_operation4.EAnnotations.add(eannotation4)
		classa.EOperations.add(classa_operation4)
		
//		val classa_typeparameter = EcoreFactory.eINSTANCE.createETypeParameter()
//		classa_typeparameter.name="T"
//		classa.ETypeParameters.add(classa_typeparameter)
//		epackage.EClassifiers.add(classa)
		
	}

	@Test def void test_caseEClass() {
		
		val diagnostic = Diagnostician.INSTANCE.validate(epackage)

		
		//Arrange
		val generator = new ModelBaseGenerator();
		
		//Action
		val result = generator.caseEClass(epackage.EClassifiers.findFirst[e|e instanceof EClass && e.name.equals("ClassA")] as EClass).toString()
		System.out.println(result)
		
		//Assert
		//https://github.com/antlr/antlr4/blob/master/doc/tree-matching.md
		
		val xpath = "//methodSignature";
		val lexer = new TypeScriptLexer(CharStreams.fromString(result));
		val tokens = new CommonTokenStream(lexer);
		val parser = new TypeScriptParser(tokens);
		
		
		
		
		parser.setBuildParseTree(true);
		val tree = parser.program();
		val ruleNamesList = Arrays.asList(parser.getRuleNames());
		val prettyTree = TreeUtils.toPrettyTree(tree, ruleNamesList);
		System.out.println(prettyTree)
		
		val x = XPath.findAll(tree, xpath, parser).toSet;
		
		
	}
	
}
