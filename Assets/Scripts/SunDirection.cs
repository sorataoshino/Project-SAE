using UnityEngine;

public class SunDirection : MonoBehaviour
{
    private void Start()
    {
        Shader.SetGlobalVector("_SunDirection", transform.forward);
    }

    void Update()
    {
        //If moving light during Gameplay, so Procedual Sun follows:
        //Shader.SetGlobalVector("_SunDirection", transform.forward);
    }
}
