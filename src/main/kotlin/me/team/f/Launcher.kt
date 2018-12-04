package me.team.f

import me.team.f.ast.*
import me.team.f.parsing.Analyser
import me.team.f.generator.*
import java.io.File

fun main(args: Array<String>) {

    val code = "a is 5; b is 7 * 2;\nres is a + b;\n" +
            "isOk: boolean is if a > b then true else false end;\n" +
            "inc is func(v: integer) => v + 1;\n" +
            "arr is [1, 2, 3]"

    val parseResult = Analyser.parse(code)//.root!!.toAst()

    if (parseResult.correct()) {
        val ast = parseResult.root!!
        val kotlinProgram = mutableListOf("fun main(args: Array<String>) {")

        ast.declarations.map {
            it.specificProcess(VarDeclaration::class.java) { line ->
                //            println(line)
                kotlinProgram.add("\t" + declarationToKotlin(line))
            }
        }

        kotlinProgram.add("}")

        kotlinProgram.map { println(it) }

        saveToFile(kotlinProgram)
    } else {
        val errors = parseResult.errors
        println("ERRORS:")
        errors.forEach { println("[Line: ${it.position.line}, " +
                "Column: ${it.position.col}] -> ${it.message}") }
    }

}

fun saveToFile(kotlinProgram: List<String>) {
    val outPath = "generated-src/compilation/gen_program.kt"

    File(outPath).createNewFile()

    File(outPath).printWriter().use { out ->
        kotlinProgram.map {
            out.println(it)
        }
    }
}