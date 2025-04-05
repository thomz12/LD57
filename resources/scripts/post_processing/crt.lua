crt_target = juice.graphics:create_render_target(640, 360)
crt_strenght = 0.5
chrom = 1.0
local time = 0.0

local command = juice.render_command.new()
command.shader = juice.graphics:create_shader([[
#version 330 core
layout (location = 0) in vec2 aPos;
layout (location = 1) in vec2 aTex;

out vec2 texCoord;

void main()
{
    texCoord = aTex;
	gl_Position = vec4(aPos, 0.0, 1.0);
}
]], [[
#version 330 core
out vec4 FragColor;

uniform vec2 RESOLUTION;

uniform sampler2D _texture;
uniform float _crtStrenght;
uniform float _chrom;
uniform float _time;

in vec2 texCoord;

void main()
{
    vec2 dist = 0.5 - texCoord;
    vec2 new;
    new.x = texCoord.x - dist.y * dist.y * dist.x * _crtStrenght / (RESOLUTION.x / RESOLUTION.y);
    new.y = texCoord.y - dist.x * dist.x * dist.y * _crtStrenght;

    if (new.x > 0.0 && new.x < 1.0 && new.y > 0.0 && new.y < 1.0)
    {
        float chrom = 1 / RESOLUTION.x * _chrom;
        vec3 color;
        color.r = texture(_texture, vec2(new.x + chrom, new.y)).r;
        color.g = texture(_texture, vec2(new.x, new.y)).g;
        color.b = texture(_texture, vec2(new.x - chrom, new.y)).b;

        FragColor = vec4(color, 1.0);

        vec2 pixel_pos = new * RESOLUTION;
        if(mod(floor((_time + pixel_pos.y) / 4), 2) < 1)
        {
            FragColor *= 0.99;
        }
    }
    else
    {
        FragColor = vec4(0, 0, 0, 1);
    }
}
]])
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
    command:add_uniform_render_target("_texture", entity.scripts.bloom.target1) 
end

function update(delta)
    time = time + delta * 24
end

function post_render()
    juice.graphics:push_render_target(crt_target)
    juice.graphics:clear(juice.color.new(0, 0, 0, 0))
    command:add_uniform_float("_crtStrenght", crt_strenght)
    command:add_uniform_float("_chrom", chrom)
    command:add_uniform_float("_time", time)
    juice.graphics:command(command)
    juice.graphics:pop_render_target()
end