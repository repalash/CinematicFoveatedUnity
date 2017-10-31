Shader "PersonalPost/Blur"
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
//		_MaskTex ("Mask texture", 2D) = "white" {}
        _CoeffStep ("Coefficent step", Float) = 0.32
		_MaskFactor ("Mask Factor", Range(1, 2000)) = 500
		_KernelRadius ("Kernel Radius", Range(1, 60)) = 3
		_BlurMaskCenter("Blur Mask Center", Vector) = (0.5, 0.5, 0, 0) 
		_IndicatorColor("Indicator Color", COLOR) = (1.0, 0.0, 0, 0) 
	}
	
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"
		
			uniform sampler2D _MainTex;
			uniform sampler2D _MaskTex;
			float _CoeffStep;
			int _MaskFactor;
			int _KernelRadius;
			half4 _BlurMaskCenter; 
			float4 _IndicatorColor;
			
			fixed4 _Blur1(v2f_img i, sampler2D mainTex, float blurAmount, float _coeff_step, int _kernel_radius) : COLOR {
    
            

           	    half4 texcol = half4(0.0, 0.0, 0.0, 0.0);
               float remaining=1.0f;
               float coef=1.0;
               float fI=0;
               int _flag = 1;
               for (int j = 0; j < _kernel_radius ; j++) {
                   if (_flag){
                       fI++;
                       coef*=_coeff_step;
                       texcol += tex2D(mainTex, float2(i.uv.x, i.uv.y - fI * blurAmount)) * coef;
                       texcol += tex2D(mainTex, float2(i.uv.x - fI * blurAmount, i.uv.y)) * coef;
                       texcol += tex2D(mainTex, float2(i.uv.x + fI * blurAmount, i.uv.y)) * coef;
                       texcol += tex2D(mainTex, float2(i.uv.x, i.uv.y + fI * blurAmount)) * coef;
                       remaining-=4*coef;
                   }
                   if(j>_kernel_radius*blurAmount*_MaskFactor){
                       _flag = 0;
                   }
               }
               texcol += tex2D(_MainTex, float2(i.uv.x, i.uv.y)) * remaining;
           
               return texcol;
			}

            float getBlurAmount(half2 centerCoords, half2 pointCoords) {
                float a = (centerCoords.x - pointCoords.x);
                float b = (centerCoords.y - pointCoords.y);
                return sqrt(a*a + b*b);
            }

			fixed4 frag (v2f_img i) : COLOR {
                float blurAmount = clamp(getBlurAmount(half2(_BlurMaskCenter.x, _BlurMaskCenter.y), i.uv),0.0,1.0);
		return _Blur1(i, _MainTex, blurAmount / _MaskFactor, _CoeffStep, _KernelRadius ) + _IndicatorColor*(1.0-clamp(blurAmount*10.0, 0.0, 1.0));
			}
			
			ENDCG
		}
	}
}
