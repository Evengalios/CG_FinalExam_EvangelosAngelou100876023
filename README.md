# CG_FinalExam_EvangelosAngelou100876023

# Overview
this is my a screenshot of my pacman build. I was able to make the player move and make the orbs collectible (they destroy onCollision with player) however I was unable to make eneny AI as that would take too long.
<img width="1227" height="692" alt="image" src="https://github.com/user-attachments/assets/6f7583eb-7ccd-4ebb-b5c2-ac9b89a3728b" />

# Texture(s) Used
I used one texture from my assets list
- Brick Wall - 25+ Free Styles Textures by Game Buffs
  <img width="2048" height="2048" alt="Brick_Wall_18_Albedo" src="https://github.com/user-attachments/assets/44cbe824-ebe4-430c-b353-07fd3916b1be" />

# Scrolling Texture
I implemented scrolling textures for the walls and used a brick texture. I thought having the wall textures move would make the scene look more cyber-esque and add a cool addition to the game. The shader samples a main texture (which was the brick texture I used), adds a UV scroll speed, and allows scaling for my texture. The shader tints the sampled texture with a maincolor and I added an emission multiplier to make a brighter effect. <img width="1482" height="511" alt="image" src="https://github.com/user-attachments/assets/412e5968-1dae-4a9d-b46a-1a0693f0bc25" /> <img width="921" height="797" alt="image" src="https://github.com/user-attachments/assets/b93fbec7-67e0-4454-b007-ebbe1d6921f4" />



# Holographic Shader
In this shader I made a scrolling wave (holographic) animation, and added color blending and rim lighting. It lerps between two colors based on a sine wave that moves over time, which creates the line effect. The rim lighting just brightens the hologram edges so its easier for the orbs to contrast against the black background so players can see it, and the lighting emission multipler boosts the glow. <img width="1356" height="482" alt="image" src="https://github.com/user-attachments/assets/3a514de2-ea6f-4558-aa02-f97aed4e3ea6" /> <img width="996" height="780" alt="image" src="https://github.com/user-attachments/assets/c67912a4-4d32-4791-803f-26d419a1024d" />


# Rim Lighting
I just added a basic rim lighting shader for the player and the ghosts. I wanted to focus more on the scene rather than the character objects so i give them no texture but a simple rim light so that its easy to identify where every character is at all times. Rim lighting just makes edges of an object appear brighter when viewed from certain angles. It checks how much the surface normal faces away from the camera. surfaces that are sideways from the camera catch more light, which just creates a glowing outline around the edges. <img width="320" height="316" alt="image" src="https://github.com/user-attachments/assets/09e69474-bec1-4bda-a5d7-095289f53dc7" />
<img width="350" height="295" alt="image" src="https://github.com/user-attachments/assets/7e06bcd1-6448-4d6f-aff3-843a3183ab1d" /> <img width="922" height="762" alt="image" src="https://github.com/user-attachments/assets/9022427d-e62c-4c6e-9714-67ea3081d72a" />

# Transparency 
This shader just adds realtime lighting to a transparent textured material. It uses the main light from URP to calculate Lambertian diffuse lighting, then multiplies that lighting with the sampled texture and the base color tint. This shader was extremely useful for the entrance to PacMan's starting area as the player needs to know that the area can be accessed by pacman alone. The transparent texture indicated that pacman can "phase" through it while still being protected against the ghosts <img width="535" height="636" alt="image" src="https://github.com/user-attachments/assets/bdc0f78f-fe38-4bc9-9215-7bdce589d42d" />
<img width="405" height="357" alt="image" src="https://github.com/user-attachments/assets/8cc9e197-1cd1-4c6c-915b-1a809eb87c12" />

