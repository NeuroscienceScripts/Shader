Shader "Unlit/ArgusShader"
{
    Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _xElectrodes("Number electrodes (x)", Range(0,10))=10
        _yElectrodes("Number electrodes (y)", Range(0,10))=10
        /*_xPos("Array x-position", Range(0.0,0.5)) = 0.25
        _yPos("Array y-position", Range(0.0,1.0)) = 0.2
        _Rotation("Rotation", Range(0.0,1.0)) = 1*/
        _FOV("Field of view", Range(0.0,60)) = 60
    }

    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 screenPos:TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _xPos;
            float _yPos;
            float _Rotation;
            float _FOV;
          
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); //texture scale/offset applied correctly 
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

 /****** FIELD OF VIEW *********/
                float newLeftEdge = ((60-_FOV)/2)/60;
                float newRightEdge = 1- newLeftEdge;
                float newTopEdge = newRightEdge;
                float newBottomEdge = newTopEdge;
                
                if(i.uv.x < newLeftEdge || i.uv.x > newRightEdge){
                    discard;
                 }
                 if(i.uv.y < newBottomEdge || i.uv.y > newTopEdge){
                    discard;
                 }
                 
 /******** FIND ELECTRODES *************/
               /* float newScreenWidth = newRightEdge-newLeftEdge;
                float newScreenHeight = newTopEdge-newBottomEdge;
                float electrodeDistanceX = newScreenWidth/_xElectrodes;
                float electrodeDistanceY = newScreenHeight/_yElectrodes;
                
                boolean xElectrodeLocation = false;
                boolean yElectodeLocation = false;
                /*for(int i=0; i<_xElectrodes; i++){
                    if(i.uv.x == (newLeftEdge + (i*electrodeDistanceX)){
                        xElectrodeLocation = true;
                    }
                }
                if(!xElectrodeLocation){
                    discard;
                }
                /*else{
                    for(int i=0; i<_xElectrodes; i++){
                        if(i.uv.y == (newBottomEdge + (i*electrodeDistanceX)){
                            yElectrodeLocation = true;
                        }
                    }
                }
                if(!yElectrodeLocation){
                    discard;
                }*/
  
                return col;
            }
            
            ENDCG
        }
       /* Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 screenPos:TEXCOORD1;
            };
            
           /* inline void ObjSpaceUVOffset(inout float2 screenUV, in float screenRatio)
            {
                float4 objPos = float4(UNITY_MATRIX_MVP[0].w, UNITY_MATRIX_MVP[1].w, UNITY_MATRIX_MVP[2].w, UNITY_MATRIX_MVP[3].w);
                
                float offsetFactorX = 0.5;
                float offsetFactorY = offsetFactorX * screenRatio;
                offsetFactorX *= _SketchTex_ST.x;
                offsetFactorY *= _SketchTex_ST.y;
                
                //don't scale with orthographic camera
                if (unity_OrthoParams.w < 1)
                {
                    //adjust uv scale
                    screenUV -= float2(offsetFactorX, offsetFactorY);
                    screenUV *= objPos.z;	//scale with cam distance
                    screenUV += float2(offsetFactorX, offsetFactorY);
                }
                
                screenUV.x -= objPos.x * offsetFactorX;
                screenUV.y -= objPos.y * offsetFactorY;
            }*/

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _xPos;
            float _yPos;
            float _Rotation;
            float _FOV;

            v2f vert (appdata v)
            {
                v2f o;
                /*v.vertex.x += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _Amount;*/
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = v.texcoord;
               o.uv = TRANSFORM_TEX(v.uv, _MainTex); //texture scale/offset applied correctly 
                o.screenPos = ComputeScreenPos(o.vertex);
               // o.screenPos.xy = TRANSFORM_TEX(o.sketchUv, _SketchTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               /* float2 screenUV = i.sketchUv.xy / i.sketchUv.w;
                float screenRatio = _ScreenParams.y / _ScreenParams.x;
                screenUV.y *= screenRatio;
                ObjSpaceUVOffset(screenUV, screenRatio);*/

                fixed4 col = tex2D(_MainTex, i.uv);
                float4 worldpos =  /*i.screenPos*/  _ScreenParams;
                /*
               if((i.screenPos.x > 0 && i.screenPos.x < 1.5) ){
                    // col = (0,0,0,0);
                    discard;
                }
                 if((i.screenPos.y > 0 && i.screenPos.y < 1.5)){
                        // col = (0,0,0,0);
                        discard;
                 }
                 
                if(i.uv.x < (((60-_FOV)/2)/60) || i.uv.x > (1- (((60-_FOV)/2)/60))){
                    discard;
                 }*/
                 if(i.uv.y < (((60-_FOV)/2)/60) || i.uv.y > (1- (((60-_FOV)/2)/60))){
                    col=(0,0,0,0);
                 }
  
                return col;
            }
            
            ENDCG
        }*/
    }
}