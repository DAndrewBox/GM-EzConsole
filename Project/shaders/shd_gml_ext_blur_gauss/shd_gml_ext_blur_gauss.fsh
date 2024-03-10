varying vec2	v_vTexcoord;
varying vec4	v_vColour;
uniform vec3	u_size;		// => vec3(width, height, radius)
uniform float	u_quality;	// => float(1 | 2 | 3 | 4)

#define	QUALITY		5.
#define	DIRECTIONS	18.
#define	PI			6.28318530718

void main() {
	float QUALITY_FINAL		= QUALITY * u_quality;
	float DIRECTIONS_FINAL	= DIRECTIONS * (u_quality / 2.);
	
    vec2 radius = (u_size.z / u_size.xy);
    vec4 Color = texture2D( gm_BaseTexture, v_vTexcoord);
    for(float d = .0; d < PI; d += (PI / DIRECTIONS_FINAL)) {
        for(float i = (1.0 / QUALITY_FINAL); i <= 1.0; i += (1.0 / QUALITY_FINAL)) {
			Color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(cos(d), sin(d)) * radius * i);
        }
    }
    Color /= QUALITY_FINAL * DIRECTIONS_FINAL + 1.0;
	
	if (Color.r <= .1 && Color.g <= .1 && Color.b <= .1 && Color.a <= .05) {
		gl_FragColor = vec4(1., 1., 1., .0);
	} else {
		gl_FragColor = Color * v_vColour;
	}
}