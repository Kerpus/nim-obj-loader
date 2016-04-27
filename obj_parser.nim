import "opengl-1.0/opengl"
import strutils , parseutils

type
  vert* = array[1 .. 3,GLfloat]
type
  face* = array[0 .. 2,GLuint]
type
  tex* = array[0 .. 1,GLfloat]

type
   obj_data* = object
    data_vert* : seq[vert]
    data_face* : seq[face]
    data_nrml* : seq[vert]
    data_tex* : seq[tex]
    mtl* : string
    grp* : string
    use* : string
    s*: string

proc parse_face(s:string): face =
   var f : face
   var a = split(s,' ')
   for i in 1 .. <a.high:
    var c = split(a[i],'/')
    for d in 0 .. c.high:
      if c[d] == "":
       continue
      else:
       var z = parseInt(c[d])
       result[d] = z.GLuint

proc parse_2f(s:string): tex =
   var a = split(s,' ')
   for i in 1 .. <a.high:
      var f = parseFloat(a[i])
      result[i] = f.GLfloat

proc parse_3f(s:string): vert =
   var a = split(s,' ')
   for i in 1 .. a.high:
      var p = parseFloat(a[i])
      result[i] = p.GLfloat

proc parse_mtllib(s:string): string =
   var a : string = strip(s,true,true)
   delete(a,0,6)
   return a

proc parse_group(s:string): string =
  var a : string = strip(s,true,true)
  delete(a,0,1)
  return a

proc getObjFile*(path:string): obj_data =
  var data : array[1,string] = [readFile(path).string]
  var str_seq = splitLines(data[0])
  var t : int = str_seq.len.int
  result.data_vert = @[]
  result.data_face = @[]
  result.data_nrml = @[]
  result.data_tex = @[]

  for i in 0 .. t.int:

    if startsWith(str_seq[i],"#") == true:
      continue

    if find(str_seq[i],"usemtl") != -1.int:
      result.mtl = parse_mtllib(str_seq[i])
      #echo a.mtl
      continue

    if find(str_seq[i],"mtllib") != -1.int:
      result.mtl = parse_mtllib(str_seq[i])
      #echo a.mtl
      continue

    if startsWith(str_seq[i],"o") == true:
      result.grp = parse_group(str_seq[i])
      #echo a.grp
      continue

    if startsWith(str_seq[i],"s") == true:
      result.s = parse_group(str_seq[i])
      #echo a.grp
      continue

    if startsWith(str_seq[i],"f") == true:
      var f = parse_face(str_seq[i])
      result.data_face.add(f)
      continue

    if startsWith(str_seq[i],"vn") == true:
      var vn = parse_3f(str_seq[i])
      result.data_nrml.add(vn)
      continue

    if startsWith(str_seq[i],"vt") == true:
      var vt = parse_2f(str_seq[i])
      result.data_tex.add(vt)
      continue

    if startsWith(str_seq[i],"v") == true:
      var v = parse_3f(str_seq[i])
      result.data_vert.add(v)
      #echo a.data_vertex
      continue

    if startsWith(str_seq[i]," ") == true:
      continue

    break
