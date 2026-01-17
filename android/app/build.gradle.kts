plugins {
    id("org.jetbrains.kotlin.plugin.compose").version("2.1.20")// this version matches your Kotlin version
    id("com.android.application")
}

android {
    compileSdk = 35

    defaultConfig {
        applicationId = "uk.co.amlcurran.social"
        minSdk = 23
        versionCode = 1
        versionName = "1.0"
    }
    buildTypes {
        release {
            isMinifyEnabled = true
            //proguardFiles += listOf(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        debug {
//            debuggable = false
        }
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }

    namespace = "uk.co.amlcurran.social"
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}

dependencies {
    implementation("com.google.maps.android:android-maps-utils:2.4.0")
    implementation("com.google.android.libraries.places:places:3.0.0")
    implementation("com.google.android.material:material:1.8.0")

    implementation("androidx.recyclerview:recyclerview:1.3.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.fragment:fragment-ktx:1.5.6")
    implementation("androidx.lifecycle:lifecycle-extensions:2.2.0")
    implementation("androidx.preference:preference-ktx:1.2.0")
    implementation("androidx.core:core-ktx:1.9.0")
    implementation("androidx.work:work-runtime-ktx:2.10.1")

    implementation("joda-time:joda-time:2.10.5")

    implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.3.0")
    val composeBom = platform("androidx.compose:compose-bom:2025.04.01")
    implementation(composeBom)

    implementation("com.google.maps.android:maps-compose:5.0.4")

    // Widgets
    implementation("androidx.glance:glance-appwidget:1.1.1")
    implementation("androidx.glance:glance-material3:1.1.1")
    implementation("androidx.glance:glance-appwidget-preview:1.1.1")
    implementation("androidx.glance:glance-preview:1.1.1")

    implementation("androidx.compose.material3.adaptive:adaptive:1.2.0-beta03")
    implementation("androidx.compose.material3.adaptive:adaptive-layout:1.2.0-beta03")
    implementation("androidx.compose.material3.adaptive:adaptive-navigation:1.2.0-beta03")

    implementation("androidx.compose.ui:ui")
    debugImplementation("androidx.compose.ui:ui-tooling")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.activity:activity-compose:1.10.1")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.7")
    implementation("androidx.compose.material:material-icons-core")
    implementation("androidx.compose.runtime:runtime-livedata")
    implementation(project(":shared"))
}

repositories {
    mavenCentral()
}
