Shader "MyShader/Clip"
{
	
	  Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        
         _ClipRect ("ClipRect", Vector) = (0, 0, 1, 1)    // 颜色

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        [Header(Dissolve)]
        _NoiseTex("Noise Texture (A)", 2D) = "white" {}
        _DissolveRange("DissolveRange",Range(0,1.0)) = 0.5
        _DissolveWidth("DissolveWidth",Range(0,1.0)) = 0.5
        _DissolveSoftness("DissolveSoftness",Range(0,1.0)) = 0.5
        _DissolveColor ("DissolveColor", Color) = (1,1,1,1)
    }
		SubShader
		{

			Pass
			{

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"
				#include "UnityUI.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
		
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					float4 worldPosition : TEXCOORD1;
				};

				float4 _ClipRect;

				v2f vert(appdata v)
				{
					v2f o;
					o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
					o.vertex = UnityObjectToClipPos(o.worldPosition);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{ 
					fixed4 col;
					float xx = UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
					if (xx > 0)
					{
						col = fixed4(1, 0, 0, 1);
					}
					else
					{
						col = fixed4(1, 1, 0, 1);
					}

					return col;
				}
				ENDCG
			}
		}
}
