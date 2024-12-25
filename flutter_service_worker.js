'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"favicon-16x16.png": "26cd365b86c7ac3477f5c3dfe1cd0ca5",
"assets/img/settings.png": "ab65f47b70a7bdf755b0b5f42aee7e36",
"assets/img/logo.png": "345ca94f0d9ca768a73270b638977a88",
"assets/img/lounge_img3.png": "e45a67dd8c802e0774d4bedffec42f32",
"assets/img/lounge_img1.png": "d279525ded9ea0705b63528a69f25ec3",
"assets/img/lounge_img10.png": "ec1b230bbf4c4b91ee1b3f97287d8305",
"assets/img/navigation.png": "3d87cfe4a1eeee2193ba7a8341ceb490",
"assets/img/lounge_img4.png": "e2f28d05b1c8923f051226bbc51a6c01",
"assets/img/lounge_img2.png": "1930e65e49f29db6e50ed00036ed8d46",
"assets/img/lounge_img9.png": "3dc36115a9d423baa952e62649823e64",
"assets/assets/img/settings.png": "ab65f47b70a7bdf755b0b5f42aee7e36",
"assets/assets/img/logo.png": "345ca94f0d9ca768a73270b638977a88",
"assets/assets/img/lounge_img3.png": "e45a67dd8c802e0774d4bedffec42f32",
"assets/assets/img/lounge_img1.png": "d279525ded9ea0705b63528a69f25ec3",
"assets/assets/img/lounge_img10.png": "ec1b230bbf4c4b91ee1b3f97287d8305",
"assets/assets/img/navigation.png": "3d87cfe4a1eeee2193ba7a8341ceb490",
"assets/assets/img/lounge_img4.png": "e2f28d05b1c8923f051226bbc51a6c01",
"assets/assets/img/lounge_img2.png": "1930e65e49f29db6e50ed00036ed8d46",
"assets/assets/img/lounge_img9.png": "3dc36115a9d423baa952e62649823e64",
"assets/assets/img/lounge_img5.png": "fdc96bcd5fe730ac7c66dc3de94de404",
"assets/assets/fonts/Pretendard-Light.ttf": "77ecd2ca94928e38ff7c68bb255324f7",
"assets/assets/fonts/Pretendard-Bold.ttf": "dfb614ebecd405875f50a918ca11c17c",
"assets/assets/fonts/Pretendard-Medium.ttf": "7305f90c923d4409825ec2f4380b63d6",
"assets/assets/fonts/Pretendard-SemiBold.ttf": "459eff7ba5380583ccd6eda49c846c85",
"assets/assets/fonts/Pretendard-Thin.ttf": "8b65a9299b173e635e6acac200e80257",
"assets/assets/fonts/Pretendard-Regular.ttf": "d6e0de06bff8b7fda2db4682168e3ddf",
"assets/assets/fonts/Pretendard-ExtraLight.ttf": "2f39a307ce00aa5e734137d4cee3b5c1",
"assets/assets/fonts/Pretendard-ExtraBold.ttf": "332e9b673b0c1709e93fee01e4543f1d",
"assets/assets/fonts/Pretendard-Black.ttf": "51c73880d5964b36e6373b3fe31f3058",
"assets/AssetManifest.bin": "8643a6a0b3fb61765832bce3e18cc238",
"assets/NOTICES": "c64ef30a96284a3243d4fa95783911bd",
"assets/AssetManifest.json": "174c873b58da67bc795413d5610389ef",
"assets/fonts/Pretendard-Light.ttf": "77ecd2ca94928e38ff7c68bb255324f7",
"assets/fonts/Pretendard-Bold.ttf": "dfb614ebecd405875f50a918ca11c17c",
"assets/fonts/Pretendard-Medium.ttf": "7305f90c923d4409825ec2f4380b63d6",
"assets/fonts/Pretendard-SemiBold.ttf": "459eff7ba5380583ccd6eda49c846c85",
"assets/fonts/Pretendard-Thin.ttf": "8b65a9299b173e635e6acac200e80257",
"assets/fonts/Pretendard-Regular.ttf": "d6e0de06bff8b7fda2db4682168e3ddf",
"assets/fonts/Pretendard-ExtraLight.ttf": "2f39a307ce00aa5e734137d4cee3b5c1",
"assets/fonts/Pretendard-ExtraBold.ttf": "332e9b673b0c1709e93fee01e4543f1d",
"assets/fonts/MaterialIcons-Regular.otf": "c4c0651310bed5b90f86a14f2d0bd88d",
"assets/fonts/Pretendard-Black.ttf": "51c73880d5964b36e6373b3fe31f3058",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/FontManifest.json": "fc2ac3061e6e95ebc02b7994c706a9dd",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "f0880bb8016406ca173cabd5a16484e5",
"version.json": "c4ddd3dd9690565d37a2cc3c63fd0f3b",
"manifest.json": "84a7b3f17d31ab8572ddd592f96f745d",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"index.html": "571008dd1e5de58ca2d28d12be785572",
"/": "571008dd1e5de58ca2d28d12be785572",
"favicon.ico": "90d91ad8a31740f300e9be3c9f1f83a9",
"apple-icon.png": "5726f42e45e38b5a4d9050af060888b5",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "d597bf57002bcb63e3de30e99fd3783e",
"CNAME": "d61aa39a6449b590b82912182f32a8f0",
"main.dart.js": "a7a0479ca6794eb81980987239e6af69",
"apple-touch-icon.png": "dbcf5d3561970cb953efb1cf26a53bb2",
"favicon-32x32.png": "839727219e8ea4694bc8453030536058"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
