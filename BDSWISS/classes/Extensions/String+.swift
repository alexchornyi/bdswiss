//
//  String+.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import Foundation

extension String {
   func first(char:Int) -> String {
        return String(self.prefix(char))
    }

    func last(char:Int) -> String
    {
        return String(self.suffix(char))
    }

    func excludingFirst(char:Int) -> String {
        return String(self.suffix(self.count - char))
    }

    func excludingLast(char:Int) -> String
    {
         return String(self.prefix(self.count - char))
    }
 }
