Shader "Unlit/Mofade"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _ClipRect ("ClipRect", Vector) = (0, 0, 1, 1) // 颜色

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0


        _Ramp("Ramp",2D) = "white"{}
        _Blend("Blend",Range(0,1.1)) = 0
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 srcPos : TEXCOORD2;
                fixed4 color : COLOR;
                float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex, _Ramp;
            float4 _MainTex_ST, _Ramp_ST;
            float _Blend;

            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;

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

                // #ifdef UNITY_UI_CLIP_RECT
                // col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                // #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (min(col.a - 0.5, 0.6));
                #endif

                // half4 temp = fixed4(tex2D(_Ramp, noiseUV).rgb, 1);
                //
                // col.rgb += temp.rgb * temp.a;

                col.a *= smoothstep(0, 0.1, _Blend - cutout);


                return col;
            }
            ENDCG
        }
    }
}