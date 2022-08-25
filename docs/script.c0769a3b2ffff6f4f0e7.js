/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ 833:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
// extracted by mini-css-extract-plugin


/***/ }),

/***/ 279:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
__webpack_require__.r(__webpack_exports__);
// extracted by mini-css-extract-plugin


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	(() => {
/******/ 		// define __esModule on exports
/******/ 		__webpack_require__.r = (exports) => {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	})();
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be isolated against other modules in the chunk.
(() => {
__webpack_require__(279);
__webpack_require__(833);
(() => {
  function bind(nodes, event, handler) {
    Array.from(nodes).forEach((node) => {
      node.addEventListener(event, handler);
    });
  }

  function makeTabs(node) {
    let selected = node.querySelector(".section__tab_active").dataset.id;
    const tabs = node.querySelectorAll(".section__tab");
    const list = Array.from(tabs).map((node) => node.dataset.id);
    const select = node.querySelector(".section__select");

    function selectTab(newId) {
      const newTab = node.querySelector(`.section__tab[data-id=${newId}]`);
      const newPanel = node.querySelector(`.section__panel[data-id=${newId}]`);
      const oldTab = node.querySelector(".section__tab_active");
      const oldPanel = node.querySelector(
        ".section__panel:not(.section__panel_hidden)"
      );

      selected = newId;

      oldTab.classList.remove("section__tab_active");
      oldTab.setAttribute("aria-selected", "false");
      oldTab.removeAttribute("tabindex");
      newTab.classList.add("section__tab_active");
      newTab.setAttribute("aria-selected", "true");
      newTab.setAttribute("tabindex", "0");
      newTab.focus({
        preventScroll: true,
      });

      oldPanel.classList.add("section__panel_hidden");
      oldPanel.setAttribute("aria-hidden", "true");
      newPanel.classList.remove("section__panel_hidden");
      newPanel.setAttribute("aria-hidden", "false");

      select.value = newId;
    }

    select.addEventListener("input", () => {
      selectTab(select.value);
    });

    bind(tabs, "click", (event) => {
      const newId = event.target.dataset.id;
      selectTab(newId);
    });

    bind(tabs, "keydown", (event) => {
      if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) {
        return;
      }

      let index = list.indexOf(selected);
      if (event.which === 37) {
        // left
        --index;
      } else if (event.which === 39) {
        // right
        ++index;
      } else if (event.which === 36) {
        // home
        index = 0;
      } else if (event.which === 35) {
        // end
        index = list.length - 1;
      } else {
        return;
      }

      if (index >= list.length) {
        index = 0;
      } else if (index < 0) {
        index = list.length - 1;
      }

      selectTab(list[index]);
      event.preventDefault();
    });
  }

  function makeMenu(node) {
    let expanded = false;
    const links = document.querySelector(".header__links");

    node.addEventListener("click", () => {
      expanded = !expanded;
      node.setAttribute("aria-expanded", expanded ? "true" : "false");
      node.querySelector(".header__menu-text").textContent = expanded
        ? "Закрыть меню"
        : "Открыть меню";
      links.classList.toggle("header__links_opened", expanded);
      links.classList.add("header__links-toggled");
    });
  }

  document.addEventListener("DOMContentLoaded", () => {
    Array.from(document.querySelectorAll(".main__devices")).forEach(makeTabs);
    Array.from(document.querySelectorAll(".header__menu")).forEach(makeMenu);
  });
})();

})();

/******/ })()
;
//# sourceMappingURL=script.c0769a3b2ffff6f4f0e7.js.map