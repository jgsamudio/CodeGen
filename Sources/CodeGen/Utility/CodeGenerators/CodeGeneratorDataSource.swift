//
//  CodeGeneratorDataSource.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
Auto-Generated using CodeGen
*/

struct CodeGeneratorDataSource {

	static var availableGeneratorDict: [String: CodeGenerator.Type] {
		return [
			ProtocolComformanceGenerator.name: ProtocolComformanceGenerator.self,
			DelegateExtensionMarkGenerator.name: DelegateExtensionMarkGenerator.self,
			PrivateVariableMarkGenerator.name: PrivateVariableMarkGenerator.self,
			InitializationMarkGenerator.name: InitializationMarkGenerator.self,
			DeclarationHeaderGenerator.name: DeclarationHeaderGenerator.self,
			PrivateExtensionMarkGenerator.name: PrivateExtensionMarkGenerator.self,
			PublicFunctionMarkGenerator.name: PublicFunctionMarkGenerator.self,
			PublicVariableMarkGenerator.name: PublicVariableMarkGenerator.self
		]
	}

}