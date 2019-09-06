import { Elm } from '../app/Main.elm';

// A weird parcel error can happen during hotswap
// Best to just reload the whole app
if (module && module.hot) {
  window.onerror = err => {
    if (/Error: \[elm-hot\]/.test(err)) {
      window.location.reload();
    }
  };
}

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: ''
});
