import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: glitchWindow
    width: 800
    height: 600
    visible: true
    color: "black"

    // ShaderEffect for RGB glitch
    ShaderEffect {
        id: rgbGlitch
        width: parent.width
        height: parent.height
        property real time: 0
        property real glitchStrength: 2.0
        property real glitchSpeed: 2.0

        // Simple RGB shift shader
        fragmentShader: "
            uniform float time;
            uniform float glitchStrength;
            uniform float glitchSpeed;
            varying vec2 texCoord;

            void main() {
                vec2 noise = vec2(
                    sin(time * glitchSpeed) * 0.5,
                    cos(time * glitchSpeed) * 0.5
                );
                vec4 color = texture2D(texture, texCoord);
                color.r += noise.x * glitchStrength * 0.1;
                color.g += noise.y * glitchStrength * 0.1;
                color.b -= noise.x * glitchStrength * 0.1;
                gl_FragColor = color;
            }
        "

        // Animation to simulate glitch
        Animation {
            id: glitchAnim
            property: "time"
            from: 0
            to: 10
            duration: 750
            easing.type: Easing.InOutCubic
        }

        // Start animation
        onTimeChanged: {
            if (time > 10) {
                time = 0
            }
        }
    }

    // Run animation on startup
    Component.onCompleted: {
        glitchAnim.start()
    }
}
