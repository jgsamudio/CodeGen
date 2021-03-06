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
			DelegateExtensionMarkGenerator.name: DelegateExtensionMarkGenerator.self,
			InitializationMarkGenerator.name: InitializationMarkGenerator.self,
			LocalizedStringsGenerator.name: LocalizedStringsGenerator.self,
			PrivateExtensionMarkGenerator.name: PrivateExtensionMarkGenerator.self,
			PrivateVariableMarkGenerator.name: PrivateVariableMarkGenerator.self,
			ProtocolComformanceGenerator.name: ProtocolComformanceGenerator.self,
			PublicFunctionMarkGenerator.name: PublicFunctionMarkGenerator.self,
			PublicVariableMarkGenerator.name: PublicVariableMarkGenerator.self
		]
	}

}
