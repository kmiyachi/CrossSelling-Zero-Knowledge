import ast


def convert_proof(filename):
    with open(filename) as f:
        lines = f.readlines()
    # print(lines)
    result = []
    for line in lines:
        # print(line)
        s = line.split("=")
        var = s[0].rstrip()
        proof = s[1].rstrip('\n').lstrip()
        if var == 'B':
            temp = list(eval(proof))
            temp[0] = [str(i) for i in temp[0]]
            temp[1] = [str(i) for i in temp[1]]
        else:
            temp = proof.split(',')
            temp = list(temp)
            temp = [str(i) for i in temp]
        result.append(var + " = " + str(temp))
    return result


p = convert_proof('./proof.txt')
for x in p:
    print(x)
