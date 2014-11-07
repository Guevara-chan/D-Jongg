; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D's high-level declarations.
; Converted in 2010 by Chrono Syndrome.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

IncludeFile "Xors3d_decls.pbi"

;Log levels
#LOG_NO		= 5
#LOG_FATAL		= 4
#LOG_ERROR		= 3
#LOG_WARNING	= 2
#LOG_MESSAGE	= 1
#LOG_INFO		= 0

;Log targets
#LOG_HTML				= 1
#LOG_COUT				= 2
#LOG_HTML_COUT			= 3
#LOG_STRING			= 4
#LOG_HTML_STRING		= 5
#LOG_COUT_STRING		= 6
#LOG_HTML_COUT_STRING	= 7

;Skinning types
#SKIN_HARDWARE   = 0
#SKIN_HARDWAREVS = 1
#SKIN_SOFTWARE   = 2

;Light sources types
#LIGHT_DIRECTIONAL = 1
#LIGHT_POINT       = 2
#LIGHT_SPOT        = 3

;Texture filtering
#TF_NONE           = 0
#TF_POINT          = 1
#TF_LINEAR         = 2
#TF_ANISOTROPIC    = 3
#TF_ANISOTROPICX4  = 4
#TF_ANISOTROPICX8  = 5
#TF_ANISOTROPICX16 = 6

;PixelShader versions
#PS_1_1 = 0
#PS_1_2 = 1
#PS_1_3 = 2
#PS_1_4 = 3
#PS_2_0 = 4
#PS_3_0 = 5

;VertexShader versions
#VS_1_1 = 0
#VS_2_0 = 1
#VS_3_0 = 2

;Matrix semantics
#WORLD                         = 0
#WORLDVIEWPROJ                 = 1
#VIEWPROJ                      = 2
#VIEW                          = 3
#PROJ                          = 4
#WORLDVIEW                     = 5
#VIEWINVERSE                   = 6
#ADDITIONAL1                   = 7
#ADDITIONAL2                   = 8
#ADDITIONAL3                   = 9
#ADDITIONAL4                   = 10
#ADDITIONAL5                   = 11
#ADDITIONAL6                   = 12
#ADDITIONAL7                   = 13
#ADDITIONAL8                   = 14
#WORLDINVERSETRANSPOSE         = 15
#WORLDINVERSE                  = 16
#WORLDTRANSPOSE                = 17
#VIEWPROJINVERSE               = 18
#VIEWPROJINVERSETRANSPOSE      = 19
#VIEWTRANSPOSE                 = 20
#VIEWINVRSETRANSPOSE           = 21
#PROJINVERSE                   = 22
#PROJTRANSPOSE                 = 23
#PROJINVRSETRANSPOSE           = 24
#WORLDVIEWPROJTRANSPOSE        = 25
#WORLDVIEWPROJINVERSE          = 26
#WORLDVIEWPROJINVERSETRANSPOSE = 27
#WORLDVIEWTRANSPOSE            = 28
#WORLDVIEWINVERSE              = 29
#WORLDVIEWINVERSETRANSPOSE     = 30

;Antialiasing types
#AANONE      = 0
#AA2SAMPLES  = 1
#AA3SAMPLES  = 2
#AA4SAMPLES  = 3
#AA5SAMPLES  = 4
#AA6SAMPLES  = 5
#AA7SAMPLES  = 6
#AA8SAMPLES  = 7
#AA9SAMPLES  = 8
#AA10SAMPLES = 9
#AA11SAMPLES = 10
#AA12SAMPLES = 11
#AA13SAMPLES = 12
#AA14SAMPLES = 13
#AA15SAMPLES = 14
#AA16SAMPLES = 15

; Camera fog mode
#FOG_NONE     = 0
#FOG_LINEAR   = 1

; Camera projection mode
#PROJ_DISABLE		= 0
#PROJ_PERSPECTIVE	= 1
#PROJ_ORTHOGRAPHIC = 2

; Entity FX flags
#FX_NOTHING		= 0
#FX_FULLBRIGHT		= 1
#FX_VERTEXCOLOR	= 2
#FX_FLATSHEDED		= 4
#FX_DISABLEFOG		= 8
#FX_DISABLECULLING	= 16

; Entity blending modes
#BLEND_ALPHA		= 1
#BLEND_MULTIPLY	= 2
#BLEND_ADD			= 3

; Compare Macros
#CMP_NEVER			= 1
#CMP_LESS			= 2
#CMP_EQUAL			= 3
#CMP_LESSEQUAL		= 4
#CMP_GREATER		= 5
#CMP_NOTEQUAL		= 6
#CMP_GREATEREQUAL	= 7
#CMP_ALWAYS		= 8

; Axis
#AXIS_X	= 1
#AXIS_Y	= 2
#AXIS_Z	= 3

; Texture loading flags
#FLAGS_COLOR			= 1
#FLAGS_ALPHA			= 2
#FLAGS_MASKED			= 4
#FLAGS_MIPMAPPED		= 8
#FLAGS_CLAMPU			= 16
#FLAGS_CLAMPV			= 32
#FLAGS_SPHERICALENVMAP	= 64
#FLAGS_CUBICENVMAP		= 128
#FLAGS_R32F			= 256
#FLAGS_RESERVED		= 512
#FLAGS_VOLUMETEXTURE	= 1024
#FLAGS_ARBG16F			= 2048
#FLAGS_ARBG32F			= 4096

; Texture blending modes
#TEXBLEND_NONE			 = 0
#TEXBLEND_ALPHA		 = 1
#TEXBLEND_MULTIPLY		 = 2
#TEXBLEND_ADD			 = 3
#TEXBLEND_DOT3			 = 4
#TEXBLEND_LIGHTMAP		 = 5
#TEXBLEND_SEPARATEALPHA = 6

; Cube map faces
#FACE_LEFT		= 0
#FACE_FORWARD	= 1
#FACE_RIGHT	= 2
#FACE_BACKWARD = 3
#FACE_UP		= 4
#FACE_DOWN		= 5

; Entity animation types
#ANIMATION_STOP		= 0
#ANIMATION_LOOP		= 1
#ANIMATION_PINGPONG	= 2
#ANIMATION_ONE			= 3

; Collision types
#SPHERETOSHPHERE		= 1
#SPHERETOBOX			= 2
#SPHERETOTRIMESH		= 3

; Collision respones types
#RESPONSE_STOP				= 1
#RESPONSE_SLIDING			= 2
#RESPONSE_SLIDING_DOWNLOCK	= 3

; Entity picking modes
#PICK_NONE			= 0
#PICK_SPHERE		= 1
#PICK_TRIMESH		= 2
#PICK_BOX			= 3

; Sprite view modes
#SPRITE_FIXED		 = 1
#SPRITE_FREE		 = 2
#SPRITE_FREEROLL	 = 3
#SPRITE_FIXEDYAW	 = 4

; Deferred channels types
#DEFERRED_NONE		 = 0
#DEFERRED_ARGB8	 = 1
#DEFERRED_R32F		 = 2
#DEFERRED_ARGB32F	 = 3
#DEFERRED_GR16F	 = 4
#DEFERRED_RGB10A2	 = 5

; X-files optimization types
#OPTIMIZE_VERTEXCACHE	= 1
#OPTIMIZE_STRIPREORDER = 2
#OPTIMIZE_ATTRSORT		= 3

; Joystick types
#JOY_NONE		= 0
#JOY_DIGITAL	= 1
#JOY_ANALOG	= 2

;Default font handle
Global xDefaultFont

;Vector4 type
Structure Vector4D
	 x.F : y.F : z.F : w.F
EndStructure

;Matrix type
Structure Matrix
	 e11.F : e12.F : e13.F : e14.F
	 e21.F : e22.F : e23.F : e24.F
	 e31.F : e32.F : e33.F : e34.F
	 e41.F : e42.F : e43.F : e44.F
EndStructure

Macro xMeshWidth(entity, recursive = #False)
	 DLL_xMeshWidth(entity, recursive)
EndMacro

Macro xMeshHeight(entity, recursive = #False)
	 DLL_xMeshHeight(entity, recursive)
EndMacro

Macro xMeshDepth(entity, recursive = #False)
	 DLL_xMeshDepth(entity, recursive)
EndMacro

Macro xGetPixels(buffer = -1)
	 DLL_xGetPixels(buffer)
EndMacro

Macro xGetTextureData(texture, frame = 0)
	 DLL_xGetTextureData(texture, frame)
EndMacro

Macro xGetTextureDataPitch(texture, frame = 0)
	 DLL_xGetTextureDataPitch(texture, frame)
EndMacro

Macro xCreateTextureFromData(data_ptr, width, height, flags = 1 + 8, frames = 1)
	 DLL_xCreateTextureFromData(data_ptr, width, height, flags, frames)
EndMacro

Macro xEntityType(ent, cType, recurse = #False)
	DLL_xEntityType(ent, cType, recurse)
EndMacro

Macro xEntityRadius(ent, x, y = 0.0)
	DLL_xEntityRadius(ent, x, y)
EndMacro

Macro xFitMesh(entity, x, y, z, width, height, depth, uniform = #False)
	DLL_xFitMesh(entity, x, y, z, width, height, depth, uniform)
EndMacro

Macro xCreateEmitter(psystem, parent = 0)
	 DLL_xCreateEmitter(psystem, parent)
EndMacro

Macro xPSystemSetTexture(psystem, texture, frames = 1, speed = 0.0)
	DLL_xPSystemSetTexture(psystem, texture, frames, speed)
EndMacro

Macro xCreatePSystem(pointSprites = #False)
	 DLL_xCreatePSystem(pointSprites)
EndMacro

Macro xSurfaceEffectTexture(surface, name, texture, frame = 0)
	DLL_xSurfaceEffectTexture(surface, name, texture, frame)
EndMacro

Macro xSurfaceEffectVector(surface, name, x, y, z, w = 1.0)
	DLL_xSurfaceEffectVector(surface, name, x, y, z, w)
EndMacro

Macro xSurfaceEffectEntityTexture(surface, name, index = 0)
	DLL_xSurfaceEffectEntityTexture(surface, name, index)
EndMacro

Macro xLightShadowEpsilons(light, eps1, eps2 = 0.16)
	DLL_xLightShadowEpsilons(light, eps1, eps2)
EndMacro

Macro xSetShadowShader(path)
	DLL_xSetShadowShader(path)
EndMacro

Macro xInitShadows(dirSize = 512, spotSize = 512, pointSize = 128)
	DLL_xInitShadows(dirSize, spotSize, pointSize)
EndMacro

Macro xSetShadowParams(splitPlanes = 4, splitLambda = 0.95, useOrtho = #True, lightDist = 500.0)
	DLL_xSetShadowParams(splitPlanes, splitLambda, useOrtho, lightDist)
EndMacro

Macro xInitDeferred(tex1 = 1, tex2 = 1, tex3 = 2, tex4 = 0)
	DLL_xInitDeferred(tex1, tex2, tex3, tex4)
EndMacro

Macro xSetDeferredShaders(mrtShader, lightShader)
	DLL_xSetDeferredShaders(mrtShader, lightShader)
EndMacro

Macro xRenderWorldDeferred(texture = 0)
	DLL_xRenderWorldDeferred(texture)
EndMacro

Macro xCreateLog(target = 1, level = 0, filename = "log.html")
	 DLL_xCreateLog(target, level, filename)
EndMacro

Macro xJoyType(portID = 0)
	 DLL_xJoyType(portID)
EndMacro

Macro xJoyDown(key, portID = 0)
	 DLL_xJoyDown(key, portID)
EndMacro

Macro xJoyHit(key, portID = 0)
	 DLL_xJoyHit(key, portID)
EndMacro

Macro xGetJoy(portID = 0)
	 DLL_xGetJoy(portID)
EndMacro

Macro xWaitJoy(portID = 0)
	 DLL_xWaitJoy(portID)
EndMacro

Macro xJoyX(portID = 0)
	 DLL_xJoyX(portID)
EndMacro

Macro xJoyY(portID = 0)
	 DLL_xJoyY(portID)
EndMacro

Macro xJoyZ(portID = 0)
	 DLL_xJoyZ(portID)
EndMacro

Macro xJoyU(portID = 0)
	 DLL_xJoyU(portID)
EndMacro

Macro xJoyV(portID = 0)
	 DLL_xJoyV(portID)
EndMacro

Macro xJoyPitch(portID = 0)
	 DLL_xJoyPitch(portID)
EndMacro

Macro xJoyYaw(portID = 0)
	 DLL_xJoyYaw(portID)
EndMacro

Macro xJoyRoll(portID = 0)
	 DLL_xJoyRoll(portID)
EndMacro

Macro xJoyHat(portID = 0)
	 DLL_xJoyHat(portID)
EndMacro

Macro xJoyXDir(portID = 0)
	 DLL_xJoyXDir(portID)
EndMacro

Macro xJoyYDir(portID = 0)
	 DLL_xJoyYDir(portID)
EndMacro

Macro xJoyZDir(portID = 0)
	 DLL_xJoyZDir(portID)
EndMacro

Macro xJoyUDir(portID = 0)
	 DLL_xJoyUDir(portID)
EndMacro

Macro xJoyVDir(portID = 0)
	 DLL_xJoyVDir(portID)
EndMacro


Macro xGraphics3D(width, height, depth = 16, mode = 0, vsync = 0)
	
	
	DLL_xGraphics3D(width, height, depth, mode, vsync)
EndMacro

Macro xText(x, y, dText, cx = 0, cy = 0)
	DLL_xText(x, y, dText, cx, cy)
EndMacro

Macro xExtractAnimSeq(ent, ff, fl, seq = 0)
	 DLL_xExtractAnimSeq(ent, ff, fl, seq)
EndMacro

Macro xSetPixelShaderEntityTexture(ent, name, index = 0)
	DLL_xSetPixelShaderEntityTexture(ent, name, index)
EndMacro

Macro xSetEffectEntityTexture(ent, name, index = 0)
	DLL_xSetEffectEntityTexture(ent, name, index)
EndMacro

Macro xCreateListener(parent, rolloffFactor = 1.0, dopplerScale = 1.0, distanceScale = 1.0)
	 DLL_xCreateListener(parent, rolloffFactor, dopplerScale, distanceScale)
EndMacro

Macro xSetEffectTexture(ent, name, tex, frame = 0)
	DLL_xSetEffectTexture(ent, name, tex, frame)
EndMacro

Macro xSetPixelShaderTexture(ent, name, tex, frame = 0)
	DLL_xSetPixelShaderTexture(ent, name, tex, frame)
EndMacro

Macro xLoadAnimSeq(ent, path)
	 DLL_xLoadAnimSeq(ent, path)
EndMacro

Macro xSetCubeFace(tex, face = 1)
	DLL_xSetCubeFace(tex, face)
EndMacro

Macro xRect(x1, y1, x2, y2, solid = 0)
	DLL_xRect(x1, y1, x2, y2, solid)
EndMacro

Macro xOval(x, y, w, h, solid = 0)
	DLL_xOval(x, y, w, h, solid)
EndMacro

Macro xPointEntity(ent1, ent2, roll = 0.0)
	DLL_xPointEntity(ent1, ent2, roll)
EndMacro

Macro xAlignToVector(ent, x, y, z, a, f = 1.0)
	DLL_xAlignToVector(ent, x, y, z, a, f)
EndMacro

Macro xCreateCone(seg = 8, solid = 1, parent = 0)
	 DLL_xCreateCone(seg, solid, parent)
EndMacro

Macro xEntityX(ent, isGlobal = 0)
	 DLL_xEntityX(ent, isGlobal)
EndMacro

Macro xEntityY(ent, isGlobal = 0)
	 DLL_xEntityY(ent, isGlobal)
EndMacro

Macro xEntityZ(ent, isGlobal = 0)
	 DLL_xEntityZ(ent, isGlobal)
EndMacro

Macro xEntityRoll(ent, isGlobal = 0)
	 DLL_xEntityRoll(ent, isGlobal)
EndMacro

Macro xEntityYaw(ent, isGlobal = 0)
	 DLL_xEntityYaw(ent, isGlobal)
EndMacro

Macro xSetPostEffect(pe, index = 0)
	DLL_xSetPostEffect(pe, index)
EndMacro

Macro xSetPostEffectVectorF(pe, name, x, y, z, w = 1.0)
	DLL_xSetPostEffectVector(pe, name, x, y, z, w)
EndMacro

Macro xSetPostEffectVector(pe, name, vec)
	DLL_xSetPostEffectVector(pe, name, vec\x, vec\y, vec\z, vec\w)
EndMacro

Macro xSetEffectVectorF(pe, name, x, y, z, w = 1.0)
	DLL_xSetEffectVector(pe, name, x, y, z, w)
EndMacro

Macro xSetEffectVector(pe, name, vec)
	DLL_xSetEffectVector(pe, name, vec\x, vec\y, vec\z, vec\w)
EndMacro

Macro xEntityPitch(ent, isGlobal = 0)
	 DLL_xEntityPitch(ent, isGlobal)
EndMacro

Macro xDrawImage(img, x, y, frame = 0)
	DLL_xDrawImage(img, x, y, frame)
EndMacro

Macro xCreateLight(lType = 1)
	 DLL_xCreateLight(lType)
EndMacro

Macro xCreateSprite(parent = 0)
	 DLL_xCreateSprite(parent)
EndMacro

Macro xLoadSprite(path, flags = 1, parent = 0)
	 DLL_xLoadSprite(path, flags, parent)
EndMacro

Macro xSaveImage(img, path, frame = 0)
	DLL_xSaveImage(img, path, frame)
EndMacro

Macro xRectsOverlap(rect1_X, rect1_Y, rect1_Width, rect1_Height, rect2_X, rect2_Y, rect2_Width, rect2_Height)
	 RectsOverlap(rect1_X, rect1_Y, rect1_Width, rect1_Height, rect2_X, rect2_Y, rect2_Width, rect2_Height)
EndMacro

Macro xLoadTerrain(path, parent = 0)
	 DLL_xLoadTerrain(path, parent)
EndMacro

Macro xClearWorld(e = 1, b = 1, t = 1)
	DLL_xClearWorld(e, b, t)
EndMacro

Macro xCreateMesh(parent = 0)
	 DLL_xCreateMesh(parent)
EndMacro

Macro xCreateSurface(mesh, brush = 0, dynamic = #False)
	 DLL_xCreateSurface(mesh, brush, dynamic)
EndMacro

Macro xLoadBrush(path, flags = 1, xs = 1, ys = 1)
	 DLL_xLoadBrush(path, flags, xs, ys)
EndMacro

Macro xAddVertex(surf, x, y, z, u = 0.0, v = 0.0, w = 0.0)
	 DLL_xAddVertex(surf, x, y, z, u, v, w)
EndMacro

Macro xTileImage(img, x = 0, y = 0, f = 0)
	DLL_xTileImage(img, x, y, f)
EndMacro

Macro xVertexColor(surf, ver, r, g, b, a = 1.0)
	DLL_xVertexColor(surf, ver, r, g, b, a)
EndMacro

Macro xVertexU(surf, vert, tset = 0)
	 DLL_xVertexU(surf, vert, tset)
EndMacro

Macro xVertexV(surf, vert, tset = 0)
	 DLL_xVertexV(surf, vert, tset)
EndMacro

Macro xVertexW(surf, vert, tset = 0)
	 DLL_xVertexW(surf, vert, tset)
EndMacro

Macro xClearSurface(surf, verts = 1, tris = 1)
	DLL_xClearSurface(surf, verts, tris)
EndMacro

Macro xVertexTexCoords(surf, ver, u, v, w = 0.0, tset = 0)
	DLL_xVertexTexCoords(surf, ver, u, v, w, tset)
EndMacro

Macro xCreateBrush(r = 255, g = 255, b = 255)
	 DLL_xCreateBrush(r, g, b)
EndMacro

Macro xBrushColor(br, r = 255, g = 255, b = 255)
	DLL_xBrushColor(br, r, g, b)
EndMacro

Macro xBrushAlpha(b, a = 1)
	DLL_xBrushAlpha(b, a)
EndMacro

Macro xCopyMesh(ent, parent = 0)
	 DLL_xCopyMesh(ent, parent)
EndMacro

Macro xCopyEntity(ent, parent = 0, cloneBuff = 0)
	 DLL_xCopyEntity(ent, parent, cloneBuff)
EndMacro

Macro xCreateImage(w, h, f = 1)
	 DLL_xCreateImage(w, h, f)
EndMacro

Macro xLockBuffer(buf = -1)
	DLL_xLockBuffer(buf)
EndMacro

Macro xUnlockBuffer(buf = -1)
	DLL_xUnlockBuffer(buf)
EndMacro

Macro xImageBuffer(img, frame = 0)
	 DLL_xImageBuffer(img, frame)
EndMacro

Macro xTextureBuffer(tex, frame = 0)
	 DLL_xTextureBuffer(tex, frame)
EndMacro

Macro xCreateTexture(w, h, fl = 9, fr = 1)
	 DLL_xCreateTexture(w, h, fl, fr)
EndMacro

Macro xWritePixel(x, y, argb, buff = -1)
	DLL_xWritePixel(x, y, argb, buff)
EndMacro

Macro xCopyPixel(sx, sy, sbuf, dx, dy, dbuf = -1)
	DLL_xCopyPixel(sx, sy, sbuf, dx, dy, dbuf)
EndMacro

Macro xCopyPixelFast(sx, sy, sbuf, dx, dy, dbuf = -1)
	DLL_xCopyPixelFast(sx, sy, sbuf, dx, dy, dbuf)
EndMacro

Macro xWritePixelFast(x, y, argb, buff = -1)
	DLL_xWritePixelFast(x, y, argb, buff)
EndMacro

Macro xReadPixel(x, y, buff = -1)
	 DLL_xReadPixel(x, y, buff)
EndMacro

Macro xReadPixelFast(x, y, buff = -1)
	 DLL_xReadPixelFast(x, y, buff)
EndMacro

Macro xBrushShininess(b, s = 1)
	DLL_xBrushShininess(b, s)
EndMacro

Macro xBrushBlend(b, bm = 1)
	DLL_xBrushBlend(b, bm)
EndMacro

Macro xBrushFX(b, fx = 0)
	DLL_xBrushFX(b, fx)
EndMacro

Macro xBrushTexture(b, t, f = 0, i = 0)
	DLL_xBrushTexture(b, t, f, i)
EndMacro

Macro xEntityShininess(ent, s = 0)
	DLL_xEntityShininess(ent, s)
EndMacro

Macro xModifyTerrain(ent, x, y, h, rt = 0)
	DLL_xModifyTerrain(ent, x, y, h, rt)
EndMacro
Macro xCreateTerrain(size, parent = 0)
	 DLL_xCreateTerrain(size, parent)
EndMacro

Macro xEntityTexture(ent, tex, frame = 0, index = 0)
	DLL_xEntityTexture(ent, tex, frame, index)
EndMacro

Macro xDrawImageRect(img, x, y, rx, ry, rw, rh, frame = 0)
	DLL_xDrawImageRect(img, x, y, rx, ry, rw, rh, frame)
EndMacro

Macro xEntityPickMode(ent, Mode = 0, obsc = 1)
	DLL_xEntityPickMode(ent, Mode, obsc)
EndMacro

Macro xLoadFont(font, height = 12, bold = 0, italic = 0, underline = 0)
	 DLL_xLoadFont(font, height, bold, italic, underline)
EndMacro

Macro xLinePick(x, y, z, dx, dy, dz, dist = 0.0)
	 DLL_xLinePick(x, y, z, dx, dy, dz, dist)
EndMacro

Macro xAnimLength(ent, root = "")
	 DLL_xAnimLength(ent, root)
EndMacro

Macro xAnimSpeed(entity, rootBone = "")
	 DLL_xAnimSpeed(entity, rootBone)
EndMacro

Macro xSetAnimSpeed(entity, speed, rootBone = "")
	DLL_xSetAnimSpeed(entity, speed, rootBone)
EndMacro

Macro xAnimating(ent, root = "")
	 DLL_xAnimating(ent, root)
EndMacro

Macro xAnimTime(ent, root = "")
	 DLL_xAnimTime(ent, root)
EndMacro

Macro xAnimSeq(ent, root = "")
	 DLL_xAnimSeq(ent, root)
EndMacro

Macro xSetAnimTime(ent, time, setID = 0, root = "")
	DLL_xSetAnimTime(ent, time, setID, root)
EndMacro

Macro xSetAnimFrame(ent, frame, setID = 0, root = "")
	DLL_xSetAnimFrame(ent, frame, setID, root)
EndMacro

Macro xCameraProjMode(cam, Mode = 1)
	DLL_xCameraProjMode(cam, Mode)
EndMacro

Macro xCameraFogMode(cam, Mode = 0)
	DLL_xCameraFogMode(cam, Mode)
EndMacro

Macro xRenderWorld(twen = 1)
	DLL_xRenderWorld(twen)
EndMacro

Macro xUpdateWorld(speed = 1.0)
	DLL_xUpdateWorld(speed)
EndMacro

Macro xAnimate(ent, mode = 1, speed = 1.0, seq = 0, trans = 0, root = "")
	DLL_xAnimate(ent, mode, speed, seq, trans, root)
EndMacro

Macro xCreatePivot(parent = 0)
	 DLL_xCreatePivot(parent)
EndMacro

Macro xLoadAnimMesh(path, parent = 0)
	 DLL_xLoadAnimMesh(path, parent)
EndMacro

Macro xLoadMesh(path, parent = 0)
	 DLL_xLoadMesh(path, parent)
EndMacro

Macro xEntityParent(entity, parent , isglobal = 1)
	DLL_xEntityParent(entity, parent , isglobal)
EndMacro

Macro xSetSkinningMethod(method)
	DLL_xSetSkinningMethod(method)
EndMacro

Macro xCreateCamera(parent = 0)
	 DLL_xCreateCamera(parent)
EndMacro

Macro xPositionEntity(ent, x, y, z, isGlobal = 0)
	DLL_xPositionEntity(ent, x, y, z, isGlobal)
EndMacro

Macro xCreateCube(parent = 0)
	 DLL_xCreateCube(parent)
EndMacro

Macro xCreateSphere(seg = 8, parent = 0)
	 DLL_xCreateSphere(seg, parent)
EndMacro

Macro xCreateCylinder(seg = 8, solid = 1, parent = 0)
	 DLL_xCreateCylinder(seg, solid, parent)
EndMacro

Macro xCreateTorus(seg = 8, parent = 0)
	 DLL_xCreateTorus(seg, parent)
EndMacro

Macro xScaleEntity(ent, x, y, z, isGlobal = 0)
	DLL_xScaleEntity(ent, x, y, z, isGlobal)
EndMacro

Macro xMoveEntity(ent, x, y, z, isGlobal = 0)
	DLL_xMoveEntity(ent, x, y, z, isGlobal)
EndMacro

Macro xTranslateEntity(ent, x, y, z, isGlobal = 0)
	DLL_xTranslateEntity(ent, x, y, z, isGlobal)
EndMacro

Macro xRotateEntity(ent, x, y, z, isGlobal = 0)
	DLL_xRotateEntity(ent, x, y, z, isGlobal)
EndMacro

Macro xTurnEntity(ent, x, y, z, isGlobal = 0)
	DLL_xTurnEntity(ent, x, y, z, isGlobal)
EndMacro

Macro xLoadTexture(path, flag = 9)
	 DLL_xLoadTexture(path, flag)
EndMacro

Macro xGetBrushTexture(brush, index = 0)
	 DLL_xGetBrushTexture(brush, index)
EndMacro

Macro xSetVertexShaderVectorF(ent, name, x, y, z, w = 1.0)
	DLL_xSetVertexShaderVector(ent, name, x, y, z, w)
EndMacro

Macro xSetPixelShaderVectorF(ent, name, x, y, z, w = 1.0)
	DLL_xSetPixelShaderVector(ent, name, x, y, z, w)
EndMacro

Macro xSetVertexShaderVector(ent, name, vector)
	DLL_xSetVertexShaderVector(ent, name, vector\x, vector\y, vector\z, vector\w)
EndMacro

Macro xSetPixelShaderVector(ent, name, vector)
	DLL_xSetPixelShaderVector(ent, name, vector\x, vector\y, vector\z, vector\w)
EndMacro

;Scancodes for keyboard and mouse
#MOUSE_LEFT        = 0
#MOUSE_RIGHT       = 1
#MOUSE_MIDDLE      = 2
#MOUSE4            = 3
#MOUSE5            = 4
#MOUSE6            = 5
#MOUSE7            = 6
#MOUSE8            = 7
#KEY_ESCAPE        = 1
#KEY_1             = 2
#KEY_2             = 3
#KEY_3             = 4
#KEY_4             = 5
#KEY_5             = 6
#KEY_6             = 7
#KEY_7             = 8
#KEY_8             = 9
#KEY_9             = 10
#KEY_0             = 11
#KEY_MINUS         = 12
#KEY_EQUALS        = 13
#KEY_BACK          = 14
#KEY_TAB           = 15
#KEY_Q             = 16
#KEY_W             = 17
#KEY_E             = 18
#KEY_R             = 19
#KEY_T             = 20
#KEY_Y             = 21
#KEY_U             = 22
#KEY_I             = 23
#KEY_O             = 24
#KEY_P             = 25
#KEY_LBRACKET      = 26
#KEY_RBRACKET      = 27
#KEY_        = 28
#KEY_LCONTROL      = 29
#KEY_RCONTROL      = 157
#KEY_A             = 30
#KEY_S             = 31
#KEY_D             = 32
#KEY_F             = 33
#KEY_G             = 34
#KEY_H             = 35
#KEY_J             = 36
#KEY_K             = 37
#KEY_L             = 38
#KEY_SEMICOLON     = 39
#KEY_APOSTROPHE    = 40
#KEY_GRAVE         = 41
#KEY_LSHIFT        = 42
#KEY_BACKSLASH     = 43
#KEY_Z             = 44
#KEY_X             = 45
#KEY_C             = 46
#KEY_V             = 47
#KEY_B             = 48
#KEY_N             = 49
#KEY_M             = 50
#KEY_COMMA         = 51
#KEY_PERIOD        = 52
#KEY_SLASH         = 53
#KEY_RSHIFT        = 54
#KEY_MULTIPLY      = 55
#KEY_MENU          = 56
#KEY_SPACE         = 57
#KEY_F1            = 59
#KEY_F2            = 60
#KEY_F3            = 61
#KEY_F4            = 62
#KEY_F5            = 63
#KEY_F6            = 64
#KEY_F7            = 65
#KEY_F8            = 66
#KEY_F9            = 67
#KEY_F10           = 68
#KEY_NUMLOCK       = 69
#KEY_SCROLL        = 70
#KEY_NUMPAD7       = 71
#KEY_NUMPAD8       = 72
#KEY_NUMPAD9       = 73
#KEY_SUBTRACT      = 74
#KEY_NUMPAD4       = 75
#KEY_NUMPAD5       = 76
#KEY_NUMPAD6       = 77
#KEY_ADD           = 78
#KEY_NUMPAD1       = 79
#KEY_NUMPAD2       = 80
#KEY_NUMPAD3       = 81
#KEY_NUMPAD0       = 82
#KEY_DECIMAL       = 83
#KEY_TILD          = 86
#KEY_F11           = 87
#KEY_F12           = 88
#KEY_NUMPADENTER   = 156
#KEY_RMENU         = 221
#KEY_PAUSE         = 197
#KEY_HOME          = 199
#KEY_UP            = 200
#KEY_PRIOR         = 201
#KEY_LEFT          = 203
#KEY_RIGHT         = 205
#KEY_END           = 207
#KEY_DOWN          = 208
#KEY_NEXT          = 209
#KEY_INSERT        = 210
#KEY_DELETE        = 211
#KEY_LWIN          = 219
#KEY_RWIN          = 220
#KEY_BACKSPACE     = #KEY_BACK
#KEY_NUMPADSTAR    = #KEY_MULTIPLY
#KEY_LALT          = 184
#KEY_CAPSLOCK      = 58
#KEY_NUMPADMINUS   = #KEY_SUBTRACT
#KEY_NUMPADPLUS    = #KEY_ADD
#KEY_NUMPADPERIOD  = #KEY_DECIMAL
#KEY_DIVIDE        = 181
#KEY_NUMPADSLASH   = #KEY_DIVIDE
#KEY_RALT          = 56
#KEY_UPARROW       = #KEY_UP
#KEY_PGUP          = #KEY_PRIOR
#KEY_LEFTARROW     = #KEY_LEFT
#KEY_RIGHTARROW    = #KEY_RIGHT
#KEY_DOWNARROW     = #KEY_DOWN
#KEY_PGDN          = #KEY_NEXT 