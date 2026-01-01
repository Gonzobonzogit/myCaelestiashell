#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
};

layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 2) uniform customBuf {
    float progress;
    float aspectRatio;
};

void main()
{
    vec4 texColor = texture(source, qt_TexCoord0.st);

    // Calculate center position
    vec2 center = vec2(0.5, 0.5);

    // Adjust coordinates for aspect ratio to make circle truly circular
    vec2 adjustedCoord = qt_TexCoord0;
    adjustedCoord.x = (adjustedCoord.x - 0.5) * aspectRatio + 0.5;

    // Calculate distance from center
    float dist = distance(adjustedCoord, center);

    // Maximum distance from center to corner (diagonal)
    float maxDist = distance(vec2(0.5 * aspectRatio, 0.5), center);

    // Calculate reveal radius based on progress
    float revealRadius = progress * maxDist;

    // Smooth edge with feathering
    float feather = 0.05 * maxDist;
    float alpha = 1.0 - smoothstep(revealRadius - feather, revealRadius, dist);

    fragColor = texColor * alpha * qt_Opacity;
}
