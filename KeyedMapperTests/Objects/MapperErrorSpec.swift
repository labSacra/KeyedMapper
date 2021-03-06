import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct Model: Mappable {
    fileprivate enum Key: String, JSONKey {
        case stringProperty
    }

    fileprivate let stringProperty: String

    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }
}

class MapperErrorSpec: QuickSpec {
    override func spec() {
        describe("failureReason") {
            context("when the error is") {
                context("a custom error") {
                    it("should return the message associated value") {
                        let expectedValue = "message"
                        let error = MapperError.custom(field: nil, message: expectedValue)

                        expect(error.failureReason) == expectedValue
                    }
                }

                context("an invalidRawValue error") {
                    it("should return the correct message") {
                        let value = ""
                        let rawValueType = NSDictionary.self
                        let expectedMessage = "\"\(value)\" is not a valid rawValue of \(rawValueType)"
                        let error = MapperError.invalidRawValue(rawValue: value, rawValueType: rawValueType)

                        expect(error.failureReason) == expectedMessage
                    }
                }

                context("a missingField error") {
                    it("should return the correct message") {
                        let field: Model.Key = .stringProperty
                        let type = Model.self
                        let expectedMessage = "Missing field \(field.stringValue) of type \(type)"
                        let error = MapperError.missingField(field: field.stringValue, forType: type)

                        expect(error.failureReason) == expectedMessage
                    }
                }

                context("a typeMismatch error") {
                    it("should return the correct message") {
                        let field: Model.Key = .stringProperty
                        let type = Model.self
                        let value = ""
                        let expectedType = NSDictionary.self
                        let expectedMessage = "Type mismatch for field \(field) of type \(type), \"\(value)\" is a \(type(of: value)) but is expected to be \(expectedType)"
                        let error = MapperError.typeMismatch(field: field.stringValue, forType: type, value: value, expectedType: expectedType)

                        expect(error.failureReason) == expectedMessage
                    }
                }

                context("a convertible error") {
                    it("should return the correct message") {
                        let value = ""
                        let expectedType = NSDictionary.self
                        let expectedMessage = "Could not convert \(value) to type \(expectedType)"
                        let error = MapperError.convertible(value: value, expectedType: expectedType)

                        expect(error.failureReason) == expectedMessage
                    }
                }
            }
        }
    }
}
