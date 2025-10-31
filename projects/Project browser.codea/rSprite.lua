-- Sprites with rounded corners

rSprite = class()

function rSprite:init(texture)
    self.mesh = mesh()
    self.mesh.texture = texture
    self.mesh.shader = shader(
    [[uniform mat4 modelViewProjection;
    attribute vec4 position;
    attribute vec2 texCoord;
    varying highp vec2 vTexCoord;
    
    void main()
    {
    vTexCoord = texCoord;
    gl_Position = modelViewProjection * position;
    }]]
    ,
    [[precision highp float;
    uniform lowp sampler2D texture;
    uniform float r;
    varying highp vec2 vTexCoord;
    
    float rectSDF(vec2 samplePosition, vec2 halfSize){
    vec2 componentWiseEdgeDistance = abs(samplePosition) - halfSize;
    float outsideDistance = length(max(componentWiseEdgeDistance, 0.0));
    return outsideDistance;
    }
    
    void main()
    {
    vec2 position = (vTexCoord.xy);
    vec2 rectPosition = position - vec2(0.5);
    vec2 halfSize = vec2(0.5 - r);
    float d = rectSDF(rectPosition, halfSize);
    float mask = step(d, r);
    gl_FragColor = texture2D(texture, vTexCoord) * mask;
    }]])
    self.rectId = self.mesh:addRect(0, 0, 0, 0)
end

function rSprite:draw(x, y, s, r)
    if spriteMode() == CORNER then
        x = x + s/2
        y = y + s/2
    end
    self.mesh:setRect(self.rectId, x, y, s, s)
    self.mesh.shader.r = r
    self.mesh:draw()
end


