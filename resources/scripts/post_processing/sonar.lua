sonar_target = juice.graphics:create_render_target(180, 180)
sonar_speed = 1.0
sonar_noise = 0.0
local angle = 0.0

local command = juice.render_command.new()

local vertex_shader = [[
#version 330 core
layout (location = 0) in vec2 aPos;
layout (location = 1) in vec2 aTex;

out vec2 texCoord;

void main()
{
    texCoord = aTex;
	gl_Position = vec4(aPos, 0.0, 1.0);
}
]]

local fragment_shader = [[
#version 330 core
precision highp float;
out vec4 FragColor;

uniform vec2 RESOLUTION;

uniform sampler2D _texture;
uniform sampler2D _sonarTex;
uniform float _angle;
uniform float _noise;

in vec2 texCoord;

float noise(vec2 pos, float time)
{
    float e = fract((time*0.01));
    float cx  = pos.x*e;
    float cy  = pos.y*e;
    return fract(23.0*fract(2.0/fract(fract(cx*2.4/cy*23.0+pow(abs(cy/22.4),3.3))*fract(cx*time/pow(abs(cy),0.050)))));
}

void main()
{
    vec3 color = texture(_texture, texCoord).rgb;
    vec2 sonar = vec2(texCoord.x - 0.5, texCoord.y - 0.5) * mat2(cos(_angle), sin(_angle), -sin(_angle), cos(_angle));
    color *= texture(_sonarTex, sonar * 0.5 + 0.5).r;
    FragColor = vec4(color, 1.0);

    vec3 noiseVal = vec3(((0.5 + noise(texCoord, _angle) * 2.0 - 1.0) * _noise));
    FragColor = vec4(color + noiseVal, 1.0);
}
]]

if juice.platform == "web" then
    vertex_shader = vertex_shader:gsub("#version 330 core", "#version 300 es")
    fragment_shader = fragment_shader:gsub("#version 330 core", "#version 300 es")
end

command.shader = juice.graphics:create_shader(vertex_shader, fragment_shader)

command.vertex_buffer = juice.graphics:create_vertex_buffer({
    -1.0, -1.0, 0.0, 1.0,
     1.0,  1.0, 1.0, 0.0,
    -1.0,  1.0, 0.0, 0.0,

     1.0, -1.0, 1.0, 1.0,
    -1.0, -1.0, 0.0, 1.0,
     1.0,  1.0, 1.0, 0.0 }, {
    juice.vertex_attribute.new(2),
    juice.vertex_attribute.new(2)
})

function start()
    command:add_uniform_render_target("_texture", entity.camera:get_render_target())
    command:add_uniform_texture("_sonarTex", juice.resources:load_texture("sprites/sonar.png"):get_resource())
end

function update(delta)
    angle = angle + delta * sonar_speed
end

function post_render()
    juice.graphics:push_render_target(sonar_target)
    juice.graphics:clear(juice.color.new(0, 0, 0, 0))
    command:add_uniform_float("_angle", angle)
    command:add_uniform_float("_noise", sonar_noise)
    juice.graphics:command(command)
    juice.graphics:pop_render_target()
end