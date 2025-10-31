function Editor:setConstants()
    self.colors = {
        ["bg"] = color(40, 44, 52),
        ["fg"] = color(171, 178, 192),
        ["kw"] = color(199, 117, 223),
        ["sb"] = color(81, 182, 195),
        ["nb"] = color(210, 155, 98),
        ["ct"] = color(226, 107, 115),
        ["cm"] = color(92, 99, 113),
        ["st"] = color(151, 196, 117),
        ["sp"] = color(214, 182, 116),
        ["fc"] = color(93, 174, 242)
    }
    
    self.keywords = {
        "function", "self", "and", "or", "not", "nil", "if", "then", "else", "elseif", "for", "in", "do", "while", "break", "true", "false", "return", "local", "repeat", "until", "end"
    }
    self.symbols = {
        "<", "#", "%", ">", "~", "-", "+", "*", "/", "^", ".", "=", ":", ",", "[", "]", "{", "}", "(", ")", ";"
    }
    
    -- math.maxint ?
    self.constants = {
        'DYNAMIC', 'POINTER', 'SOUND_POWERUP', 'DIRECT', 'REVOLUTE', 'CANCELLED', 'SOUND_SAWTOOTH', 'SOUND_RANDOM', 'AR_LIMITED', 'STATIC', 'CAMERA', 'CIRCLE', 'SOUND_SINEWAVE', 'LANDSCAPE_LEFT', 'FULLSCREEN_NO_BUTTONS', 'SPOT', 'SOUND_SHOOT', 'LANDSCAPE_RIGHT', 'SOUND_HIT', 'CAMERA_FRONT', 'AR_ESTIMATED_PLANE', 'AR_EXISTING_PLANE_CLIPPED', 'CHAIN', 'AR_INSUFFICIENT_FEATURES', 'WIDTH', 'HEIGHT', 'DIRECTIONAL', 'AR_NORMAL', 'SOUND_JUMP', 'POLYGON', 'AR_FACE_TRACKING', 'AR_WORLD_TRACKING', 'AR_EXISTING_PLANE', 'PRISMATIC', 'AR_EXCESSIVE_MOTION', 'SOUND_EXPLODE', 'AR_NONE', 'PORTRAIT_UPSIDE_DOWN', 'OVERLAY', 'SOUND_BLIT', 'INDIRECT', 'ROPE', 'ENDED', 'SOUND_PICKUP', 'SOUND_NOISE', 'STANDARD', 'BACKSPACE', 'CAMERA_BACK', 'FULLSCREEN', 'CHANGED', 'BEGAN', 'CAMERA_DEPTH', 'POINT', 'SOUND_SQUAREWAVE', 'DISTANCE', 'EDGE', 'STYLUS', 'KINEMATIC', 'AR_NOT_AVAILABLE', 'PORTRAIT', 'AR_FEATURE_POINT', 'WELD', 'ContentScaleFactor', 'DeltaTime', 'ElapsedTime', 'CurrentTouch', 'CurrentOrientation', "CORNER", "CENTER"
    }
    
    self.functions = {
        'readProjectInfo', 'triangulate', 'buffer', 'textSize', 'fontSize', 'stopRecording', 'saveProjectData', 'camera', 'zLevel', 'saveProjectTab', 'parameter', 'vec4', 'rigidbody', 'model', 'hideKeyboard', 'music', 'listProjectTabs', 'shader', 'clearProjectData', 'listLocalData', 'speech', 'deleteProject', 'projectionMatrix', 'noTint', 'listGlobalData', 'Noise', 'entity', 'textAlign', 'clip', 'noStroke', 'noSmooth', 'rectMode', 'osc', 'mic', 'location', 'text', 'output', 'pushStyle', 'hasProject', 'saveGlobalData', 'rect', 'fill', 'spriteMode', 'ortho', 'tween', 'sound', 'readLocalData', 'vec3', 'json', 'tint', 'gesture', 'noise', 'sprite', 'spriteSize', 'pushMatrix', 'physics', 'viewMatrix', 'stroke', 'popStyle', 'ar', 'setContext', 'readText', 'listProjectData', 'keyboardBuffer', 'pasteboard', 'vec2', 'craft', 'openURL', 'readGlobalData', 'saveProjectInfo', 'showKeyboard', 'http', 'modelMatrix', 'soundbuffer', 'image', 'viewer', 'lineCapMode', 'isRecording', 'font', 'clearLocalData', 'body', 'blendMode', 'translate', 'soundsource', 'assets', 'saveText', 'bounds', 'saveLocalData', 'matrix', 'volume', 'blendEquation', 'smooth', 'pinch', 'quat', 'soundBufferSize', 'noFill', 'textWrapWidth', 'createProject', 'isKeyboardShowing', 'mesh', 'startRecording', 'ellipse', 'rotate', 'scale', 'popMatrix', 'background', 'color', 'strokeWidth', 'ipairs', 'applyMatrix', 'resetMatrix', 'readProjectData', 'hover', 'scroll', 'cameraSource', 'resetStyle', 'fontMetrics', 'voxels', 'listProjects', 'readProjectTab', 'perspective', 'ellipseMode', 'saveImage', 'line', 'textMode', 'readImage'
    }
    
    self.specials = {
        "print", "math", "tostring", "tonumber", "require", "pairs", "ipairs", "string", "table", "os", "assert", "collectgarbage", "getmetatable", "load", "pcall", "rawequal", "rawget", "rawset", "select", "setmetatable", "type", "xpcall"
    }
    
    self.syntaxTable = {}
    for i, k in ipairs(self.keywords) do
        self.syntaxTable[k] = self.colors["kw"]
    end
    for i, k in ipairs(self.symbols) do
        self.syntaxTable[k] = self.colors["sb"]
    end
    for i, k in ipairs(self.constants) do
        self.syntaxTable[k] = self.colors["ct"]
    end 
    for i, k in ipairs(self.specials) do
        self.syntaxTable[k] = self.colors["sp"]
    end  
    for i, k in ipairs(self.functions) do
        self.syntaxTable[k] = self.colors["fc"]
    end
end