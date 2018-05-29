import ast

import autopep8


class BoolFormatter:

    def isBool(self, source):
        """
        @type source: str
        """
        if ("\n" in source):
            return False
        self.source = source
        self.expr_bool = ast.parse(source).body[0]
        if 'value' in self.expr_bool._fields:
            self.expr_bool = self.expr_bool.value
            if not isinstance(self.expr_bool, ast.BoolOp):
                return False
            self.expr_values = self.expr_bool.values
            if isinstance(self.expr_bool.op, ast.And):
                self.bool_op = "and"
            elif isinstance(self.expr_bool.op, ast.Or):
                self.bool_op = "or"
            else:
                return False
            return True
        else:
            return False

    def getBoolLocation(self):
        return [v.col_offset for v in self.expr_values]

    def getOpLocation(self):
        locations = self.getBoolLocation()
        self.OpLocations = [
            self.source[0:locations[i + 1]].rfind(self.bool_op)
            for i in range(len(locations) - 1)
        ]

    def addNewLine(self):
        self.getOpLocation()
        endOpLocation = [v + len(self.bool_op) for v in self.OpLocations]
        ansSource = self.source[0:endOpLocation[0]] + "\\\n"
        for i in range(len(self.OpLocations) - 1):
            ansSource += self.source[endOpLocation[i]:endOpLocation[i + 1]
                                     ] + "\\\n"
        ansSource += self.source[endOpLocation[-1]:]
        return ansSource


def formatif(source):
    if source[:2] != "if":
        return (source, 0)
    bf = BoolFormatter()
    if bf.isBool(source[3:(source.rfind(":"))]):
        source = "if " + bf.addNewLine() + ":"
        return (autopep8.fix_code(source)[:-1], 1)
    else:
        return (source, 0)


if __name__ == "__main__":
    source = "if 1 and 1 and (1 and 1):"
    print(formatif(source))
    print(formatif("if 1+2:"))
    print(formatif("if True"))
    print(formatif("if wecanwin and youmustlose:"))
