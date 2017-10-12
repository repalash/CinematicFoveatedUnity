Shader "PersonalPost/Blur1"
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
//		_MaskTex ("Mask texture", 2D) = "white" {}
        _CoeffStep ("Coefficent step", Float) = 0.32
		_MaskFactor ("Mask Factor", Range(1, 2000)) = 500
		_KernelRadius ("Kernel Radius", Range(1, 60)) = 3
		_BlurMaskCenter("Blur Mask Center", Vector) = (0.5, 0.5, 0, 0) 
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
			
			
			fixed4 _Blur1(v2f_img i, sampler2D mainTex, float blurAmount, float _coeff_step, int _kernel_radius) : COLOR {
    
            

           	    half4 texcol = half4(0.0, 0.0, 0.0, 0.0);
               float remaining=1.0f;
               float coef=1.0;
               float fI=0;
               for (int j = 0; j < _kernel_radius; j++) {
                   fI++;
                   coef*=_coeff_step;
                   texcol += tex2D(mainTex, float2(i.uv.x, i.uv.y - fI * blurAmount)) * coef;
                   texcol += tex2D(mainTex, float2(i.uv.x - fI * blurAmount, i.uv.y)) * coef;
                   texcol += tex2D(mainTex, float2(i.uv.x + fI * blurAmount, i.uv.y)) * coef;
                   texcol += tex2D(mainTex, float2(i.uv.x, i.uv.y + fI * blurAmount)) * coef;
                   
                   remaining-=4*coef;
               }
               texcol += tex2D(_MainTex, float2(i.uv.x, i.uv.y)) * remaining;
           
               return texcol;
			}

            float getBlurAmount(half2 centerCoords, half2 pointCoords) {
                float a = (centerCoords.x - pointCoords.x);
                float b = (centerCoords.y - pointCoords.y);
                float dist = sqrt(a*a + b*b);
                return dist;
            }

			fixed4 frag (v2f_img i) : COLOR {
//			    return fixed4(i.uv, 0, 0);
                float blurAmount = getBlurAmount(half2(_BlurMaskCenter.x, _BlurMaskCenter.y), i.uv) / _MaskFactor;
//                return fixed4(blurAmount, blurAmount, blurAmount, 1);
				return _Blur1(i, _MainTex, blurAmount, _CoeffStep, _KernelRadius );
			}
			
			ENDCG
		}
	}
}
