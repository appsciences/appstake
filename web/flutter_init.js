// Initialize Flutter
function initializeFlutter() {
  // Set the build configuration
  window._flutter = {
    buildConfig: {
      version: '1.0.0',
      buildMode: 'release',
      baseUrl: '/'
    }
  };

  // Wait for Flutter engine to be ready
  window.addEventListener('flutter-first-frame', function() {
    console.log('Flutter first frame rendered');
    var loading = document.querySelector('#loading');
    if (loading) {
      loading.style.display = 'none';
    }
  });

  // Initialize Flutter
  var loading = document.querySelector('#loading');
  
  // Check if Flutter is loaded
  if (typeof _flutter !== 'undefined') {
    _flutter.loader.load({
      serviceWorker: {
        serviceWorkerVersion: serviceWorkerVersion,
      }
    }).then(function(engineInitializer) {
      return engineInitializer.initializeEngine();
    }).then(function(appRunner) {
      return appRunner.runApp();
    }).catch(function(error) {
      console.error('Error initializing Flutter:', error);
      if (loading) {
        loading.innerHTML = '<h2>Error loading app. Please refresh the page.</h2>';
      }
    });
  } else {
    console.error('Flutter engine not loaded');
    if (loading) {
      loading.innerHTML = '<h2>Error: Flutter engine not loaded. Please refresh the page.</h2>';
    }
  }
}

// Wait for the page to load
window.addEventListener('load', initializeFlutter); 