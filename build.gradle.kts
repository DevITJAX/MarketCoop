buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.8.2") // or your current version
        classpath("com.google.gms:google-services:4.4.0") // Required for Firebase
    }
}

// ... existing code ... 