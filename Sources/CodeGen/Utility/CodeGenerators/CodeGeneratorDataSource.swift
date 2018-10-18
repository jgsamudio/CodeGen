//
//  CodeGeneratorDataSource.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/18/18.
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
			InitializationMarkGenerator.name: InitializationMarkGenerator.self,
			PrivateVariableMarkGenerator.name: PrivateVariableMarkGenerator.self,
			PublicVariableMarkGenerator.name: PublicVariableMarkGenerator.self,
			PublicFunctionMarkGenerator.name: PublicFunctionMarkGenerator.self,
			PrivateExtensionMarkGenerator.name: PrivateExtensionMarkGenerator.self,
			DeclarationHeaderGenerator.name: DeclarationHeaderGenerator.self
		]
	}

}