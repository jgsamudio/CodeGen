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
			DeclarationHeaderGenerator.name: DeclarationHeaderGenerator.self,
			LocalizedStringsGenerator.name: LocalizedStringsGenerator.self,
			InitializationMarkGenerator.name: InitializationMarkGenerator.self,
			DelegateExtensionMarkGenerator.name: DelegateExtensionMarkGenerator.self,
			PrivateExtensionMarkGenerator.name: PrivateExtensionMarkGenerator.self,
			PrivateVariableMarkGenerator.name: PrivateVariableMarkGenerator.self,
			PublicFunctionMarkGenerator.name: PublicFunctionMarkGenerator.self,
			ProtocolComformanceGenerator.name: ProtocolComformanceGenerator.self,
			PublicVariableMarkGenerator.name: PublicVariableMarkGenerator.self
		]
	}

}
