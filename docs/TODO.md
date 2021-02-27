# Todo

* [x] Clean up the directories for the USD plugin... to `OamUsd.oam`
* [x] Get simple asset behaviors working
* [x] Get python bindings for oam library working
* [x] Get environment aware schemas working
* [x] Get simple schemas working
   * [x] Introduce Layers
   * [x] Introduce properties
* [-] Get CMake install targets working
* [-] Update cmake to properly export the targets to support external projects
* [x] Get oam plugins implemented
   * [ ] Make envs env var/JSON driven
* [ ] Get environment aware asset behaviors working for Maya
   * [ ] Make Maya env
   * [ ] Setup Maya env to be able to setup a remote command port

## Questions

* [x] Should we use prim kind to mirror asset type?

## Library Directory Structure

* `lib/liboam.so`: Main OAM library
* `lib/python/oam/__init__.py`
   * `lib/python/oam/Oam/_oam.so`: OAM Python library

```py
from oam import Oam
Oam.Manager()
Oam.OamInterface.GetInterface()
Oam.AssetModelAPI
```

## Kitchen Set Pixar Schema

- Kitchen_Set
   + payloadAssetDependencies

- Envs
  - Kitchen
- Props
   - MeasuringSpoon
   - Nail
   - Pan
   - Pot
   - Strainer
   - BottleB

```js
assetTypes = {
   prop: {
      baseType: component
      properties: {
         name : { type: int }
         name : { type: asset }
      }
      layers : [
         model: {
            type: modeling
         }
         texture: {
            type: texturing
         }
      ]
   }
}
```

```js
layerTypes = {
   modeling: {
      properties: {
         model_file: { type: asset }
      }
   }
   texturing: {
      properties: []
   }
}
```
