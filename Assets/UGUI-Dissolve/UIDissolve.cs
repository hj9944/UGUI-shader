using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class UIDissolve : MonoBehaviour
{
	public static string ShaderName = "Unlit/Mofade";
	[SerializeField]
	private Material _defaultMaterial = null;

	[SerializeField]
	private Graphic[] _graphics;

	public Graphic[] Graphics
	{
		get
		{
			if (_graphics == null)
			{
			}
			_graphics = GetComponentsInChildren<Graphic>();

			return _graphics;
		}
	}

	
	private Material[] oldMats;

	void OnEnable()
	{
		// _range = defaultMaterial.GetFloat("_DissolveRange");
		// _width = defaultMaterial.GetFloat("_DissolveWidth");
		// _softness = defaultMaterial.GetFloat("_DissolveSoftness");
		// noiseTex = defaultMaterial.GetTexture("_NoiseTex");
		// if (noiseTex == null)
		// {
		// 	NoiseTex = GetComponent<DefaultNoise>()?.Noise;
		// }
		// noiseScale = defaultMaterial.GetTextureScale("_NoiseTex");
		oldMats = new Material[Graphics.Length];
		for(int i=0;i< Graphics.Length;i++)
		{
			Graphics[i].material = _defaultMaterial;
		}
	}

}
