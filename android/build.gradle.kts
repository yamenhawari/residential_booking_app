allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

plugins {
    // ------------------------------------------------------
    // FIX: Updated Kotlin version to 2.1.0 to match your classpath
    // ------------------------------------------------------
    
    // Google Services (Firebase)
    id("com.google.gms.google-services") version "4.4.2" apply false

    // Kotlin - Set to 2.1.0 to fix the "already on classpath" error
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}