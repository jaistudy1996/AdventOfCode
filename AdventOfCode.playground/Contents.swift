import Cocoa

// Array extensions
extension Array {
    mutating func popFirst() -> Element? {
        if !self.isEmpty {
            return removeFirst()
        }
        return nil
    }
}

extension String {
    mutating func popFirst() -> String? {
        if !self.isEmpty {
            return String(removeFirst())
        }
        return nil
    }
}

enum Operator: String {
    case add = "+"
    case sub = "-"
    case mul = "*"
    case div = "/"
}

struct NumberWithOperator {
    let operation: Operator
    let value: Int

    init(_ input: String) {
        var varInput = input
        if let operation = Operator(rawValue: varInput.popFirst() ?? "") {
            self.operation = operation
            value = Int(varInput) ?? 0
        } else {
            operation = .add
            value = Int(input) ?? 0
        }
    }

    static func calculate(first: NumberWithOperator, second: NumberWithOperator) -> Int {
        var total = 0
        switch first.operation {
        case .add:
            total += first.value
        case .sub:
            total -= first.value
        case .mul:
            total *= first.value
        case .div:
            total /= first.value
        }

        switch second.operation {
        case .add:
            total += second.value
        case .sub:
            total -= second.value
        case .mul:
            total *= second.value
        case .div:
            total /= second.value
        }
        return total
    }
}

func day1_1() {
    var total = 0
    if var fileURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
        fileURL.appendPathComponent("Projects/adventOfCode/input_1.txt")
        print(fileURL.path)
        do {
            try String(contentsOf: fileURL, encoding: .utf8).components(separatedBy: "\n").forEach {
                let numWithOperator = NumberWithOperator($0)
                let totalWithOperator = NumberWithOperator(String(total))
                total = NumberWithOperator.calculate(first: totalWithOperator, second: numWithOperator)
            }
            print(total)
        } catch {
            print(error.localizedDescription)
            return
        }
    }

}

//day1_1()

var freqToCount = [0:1]
func day1_2() {
    var total = 0
    let fileIterator = { (fileURL: URL, total: Int) -> (Int, Bool) in
        var total = total
        var secondFrequency = false
        do {
            // need to drop last because that is an empty string
            let numbers = try String(contentsOf: fileURL, encoding: .utf8).components(separatedBy: "\n").dropLast()
            for number in numbers {
                let numWithOperator = NumberWithOperator(number)
                let totalWithOperator = NumberWithOperator(String(total))
                total = NumberWithOperator.calculate(first: totalWithOperator, second: numWithOperator)
                if let existingNumber = freqToCount[total] {
                    freqToCount[total] = existingNumber + 1
                    if freqToCount[total] == 2 {
                        secondFrequency = true
                        break
                    }
                } else {
                    freqToCount[total] = 1
                }
            }
        } catch {
            print(error.localizedDescription)
            return (0, false)
        }
        return (total, secondFrequency)
    }
    if var fileURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
        fileURL.appendPathComponent("Projects/adventOfCode/input_1.txt")
        var loopFile = fileIterator(fileURL, total)
        while !loopFile.1 {
            total = loopFile.0
            loopFile = fileIterator(fileURL, total)
        }
        print(loopFile)
    }
}

day1_2()
