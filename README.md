# SwiftCodeGenerator

**Helps to create copy function in structs, like Haskell and Scala**
_In Haskell, is known as record syntax_

1. Crear un "copy-config.json" en el raíz del proyecto.
2. Formato del "copy-config.json": 
{
    "paths": [
        _path completo del struct a generar copy_
    ]
}
4. Correr en el raíz del proyecto 'swift build'
5. Correr 'swift run SwiftCodeGenerator .'
