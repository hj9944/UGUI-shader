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

![image-20230204221900160](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20230204221900160.png)
