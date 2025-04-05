target1 = juice.graphics:create_render_target(320, 180)
target2 = juice.graphics:create_render_target(320, 180)

blur_iterations = 5
cutoff_val = 0.8

local source_target = nil

local cutoff_command = juice.render_command.new()
local blur_command = juice.render_command.new()
local combine_command = juice.render_command.new()

-- Create full screen vertex buffer.
blur_command.vertex_buffer = juice.graphics:create_vertex_buffer({
    -1.0, -1.0, 0.0, 0.0,
     1.0,  1.0, 1.0, 1.0,
    -1.0,  1.0, 0.0, 1.0,

     1.0, -1.0, 1.0, 0.0,
    -1.0, -1.0, 0.0, 0.0,
     1.0,  1.0, 1.0, 1.0 }, {
    juice.vertex_attribute.new(2),
    juice.vertex_attribute.new(2)
})
cutoff_command.vertex_buffer = blur_command.vertex_buffer
combine_command.vertex_buffer = blur_command.vertex_buffer

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

local blur_fragment_shader = [[
#version 330 core
precision highp float;
out vec4 FragColor;

uniform vec2 RESOLUTION;

uniform vec2 _direction;
uniform sampler2D _texture;
const float _weights[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

in vec2 texCoord;

void main()
{
    vec2 texOffset = 1.0 / vec2(textureSize(_texture, 0));
    vec3 result = texture(_texture, texCoord).rgb * _weights[0];

    for(int i = 1; i < 5; ++i)
    {
        result += texture(_texture, texCoord + texOffset * float(i) * _direction).rgb * _weights[i];
        result += texture(_texture, texCoord - texOffset * float(i) * _direction).rgb * _weights[i];
    }
    
    FragColor = vec4(result, 1.0);
}
]]

local cutoff_fragment_shader = [[
#version 330 core
precision highp float;
out vec4 FragColor;

uniform sampler2D _texture;
uniform float _cutoff;
in vec2 texCoord;

void main()
{
    vec4 color = texture(_texture, texCoord);
    float lum = (color.r * 2.0 + color.b + color.g * 3.0) / 6.0;
    if (lum > _cutoff)
    {
        FragColor = color;
    }
    else
    {
        FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
]]

local combine_fragment_shader = [[
#version 330 core
precision highp float;
out vec4 FragColor;

uniform sampler2D _texture;
uniform sampler2D _bloom;
in vec2 texCoord;

void main()
{
    vec3 color = texture(_texture, texCoord).rgb;
    vec3 bloom = texture(_bloom, texCoord).rgb;
    FragColor = vec4(color + bloom, 1.0);
}
]]

if juice.platform == "web" then
    vertex_shader = vertex_shader:gsub("#version 330 core", "#version 300 es")
    blur_fragment_shader = blur_fragment_shader:gsub("#version 330 core", "#version 300 es")
    cutoff_fragment_shader = cutoff_fragment_shader:gsub("#version 330 core", "#version 300 es")
    combine_fragment_shader = combine_fragment_shader:gsub("#version 330 core", "#version 300 es")
end

-- Create the shaders.
blur_command.shader = juice.graphics:create_shader(vertex_shader, blur_fragment_shader)
cutoff_command.shader = juice.graphics:create_shader(vertex_shader, cutoff_fragment_shader)
combine_command.shader = juice.graphics:create_shader(vertex_shader, combine_fragment_shader)

function post_render()
    -- Make sure we have a source texture.
    if source_target == nil then
        source_target = entity.camera:get_render_target()
    end

    -- Cutoff bright colors.
    juice.graphics:push_render_target(target2)
    juice.graphics:clear(juice.color.new(0, 0, 0, 0))
    cutoff_command:add_uniform_render_target("_texture", source_target)
    cutoff_command:add_uniform_float("_cutoff", cutoff_val)
    juice.graphics:command(cutoff_command)
    juice.graphics:pop_render_target()

    -- Blur bright colors
    for i = 1, blur_iterations do
        juice.graphics:push_render_target(target1)
        juice.graphics:clear(juice.color.new(0, 0, 0, 0))
        blur_command:add_uniform_render_target("_texture", target2)
        blur_command:add_uniform_vec2("_direction", juice.vec2.new(1, 0))
        juice.graphics:command(blur_command)
        juice.graphics:pop_render_target()
        
        juice.graphics:push_render_target(target2)
        juice.graphics:clear(juice.color.new(0, 0, 0, 0))
        blur_command:add_uniform_render_target("_texture", target1)
        blur_command:add_uniform_vec2("_direction", juice.vec2.new(0, 1))
        juice.graphics:command(blur_command)
        juice.graphics:pop_render_target()
    end

    -- Combine blur with source.
    juice.graphics:push_render_target(target1)
    juice.graphics:clear(juice.color.new(0, 0, 0, 0))
    combine_command:add_uniform_render_target("_texture", source_target)
    combine_command:add_uniform_render_target("_bloom", target2)
    juice.graphics:command(combine_command)
    juice.graphics:pop_render_target()
end