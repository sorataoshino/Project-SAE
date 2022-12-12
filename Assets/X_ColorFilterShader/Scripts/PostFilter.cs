using UnityEngine;

namespace ColorFilter
{
    [ExecuteInEditMode]
    public class PostFilter : MonoBehaviour
    {
        public Material filter;

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (filter == null)
                Graphics.Blit(source, destination);
            else
                Graphics.Blit(source, destination, filter);
        }
    }
}
