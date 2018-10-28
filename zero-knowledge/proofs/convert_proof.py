import ast
import os
import json


def convert_proof(filename):
    with open(filename) as f:
        lines = f.readlines()
        lines = lines[20:28]
    # print(lines)
    result = []
    js_result = []
    for line in lines:
        # print(line)
        s = line.split("=")
        var = s[0].rstrip()
        proof = s[1].rstrip('\n').lstrip()
        if var == 'B':
            temp = proof.split('], [')
            temp[0] = temp[0][1:]
            temp[1] = temp[1][:-1]
            t0 = temp[0].split(',')
            t1 = temp[1].split(',')
            t0 = list(t0)
            t1 = list(t1)
            temp = [[str(i).lstrip() for i in t0],
                    [str(i).lstrip() for i in t1]]
        else:
            temp = proof.split(',')
            temp = list(temp)
            temp = [str(i).lstrip() for i in temp]
        result.append(var + " = " + str(temp))
        js_result.append(temp)
    return js_result


proof_dict = {}
for filename in os.listdir("./"):
    # print(filename)
    if filename.endswith(".py"):
        continue
    else:
        p = convert_proof(filename)
        proof_dict[filename[:1]] = p

# print(proof_dict)

json_proof = json.dumps(proof_dict)
print(json_proof)

# with open("./hope.json", 'w') as outfile:
#    json.dump(json_proof, outfile)

with open("./idk.json", 'w') as out:
    out.write(proof_dict)
