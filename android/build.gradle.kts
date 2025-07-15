allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Only customize buildDir if you have a strong reason
// If you must, do it like this:
subprojects {
    // Uncomment the next line only if you are sure
    // buildDir = file("${rootProject.projectDir}/../../build/${project.name}")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
