# UGUI-shader 自定义效果

参考[消融开源链接](https://github.com/mob-sakai/DissolveEffectForUGUI)

思路:1.

```
		_graphics = GetComponentsInChildren<Graphic>();
        for(int i=0;i< Graphics.Length;i++)
        {
        	Graphics[i].material = _defaultMaterial;
        }
```

​    2.使用点在屏幕上位置，作为的噪声贴图采样的uv值。

```
v2f vert(appdata v)
{
    v2f o = (v2f)0;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

    o.worldPosition = v.vertex;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.srcPos = ComputeScreenPos(o.vertex);
    o.texcoord.xy = v.texcoord;
    o.texcoord.zw = v.texcoord.xy * _Ramp_ST.xy + _Ramp_ST.zw;
    o.color = v.color;

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    float2 noiseUV = float2(i.srcPos.xy * _Ramp_ST + _Ramp_ST.zw);
    float cutout = tex2D(_Ramp, noiseUV).r;
    fixed4 col = (tex2D(_MainTex, i.texcoord.xy) + _TextureSampleAdd) * i.color;

    #ifdef UNITY_UI_CLIP_RECT
    col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
    #endif

    #ifdef UNITY_UI_ALPHACLIP
    clip (min(col.a - 0.5, 0.6));
    #endif

    col.a *= smoothstep(0, 0.1, _Blend - cutout);


    return col;
}
```
