package org.kew.shs.dedupl

import java.io.File.TempDirectory;
import java.nio.file.Files

import cucumber.api.DataTable
import cucumber.api.PendingException;

import org.kew.shs.dedupl.util.DeduplApp

this.metaClass.mixin(cucumber.api.groovy.Hooks)
this.metaClass.mixin(cucumber.api.groovy.EN)

// define input and output files
def tempDir = Files.createTempDirectory("dedup_ipni_species")
def tempConfigFile = new File([tempDir, "config.xml"].join(File.separator))
tempConfigFile = tempConfigFile.toPath()
def tempInputFile = new File([tempDir, "input.txt"].join(File.separator)) 
tempInputFile = tempInputFile.toPath()
def tempOutputFile = new File([tempDir, "output.txt"].join(File.separator)) 
tempOutputFile = tempOutputFile.toPath()

After() {
	tempDir.toFile().deleteDir()
}

Given(~'^Rachel has created an input-file to feed the deduplicator framework containing tab-separated Genus data$') {DataTable fileContent ->
	tempInputFile.toFile().withWriter { out ->
		fileContent.asList().each {out.println it.join("\t")}
	}
}

Given(~'^Alecs has set up a configuration file according to her specs:$') { String configXML ->
	tempConfigFile.toFile().write(configXML.asType(String))
}

When(~'^this is run through the Dedupl App$') { ->
	String[] args = ["-d", tempDir.toString() + "/"]
	DeduplApp.main(args)
}

Then(~'^a file should have been created in the same folder with the following data:$') { DataTable expectedOutput ->
	tempOutputFile.toFile().readLines().each {
		System.out.println(it)
	}
	// Express the Regexp above with the code you wish you had
	throw new PendingException()
}
