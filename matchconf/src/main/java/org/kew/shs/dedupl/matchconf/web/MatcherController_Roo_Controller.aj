// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.kew.shs.dedupl.matchconf.web;

import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.kew.shs.dedupl.matchconf.Matcher;
import org.kew.shs.dedupl.matchconf.web.MatcherController;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect MatcherController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String MatcherController.create(@Valid Matcher matcher, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, matcher);
            return "matchers/create";
        }
        uiModel.asMap().clear();
        matcher.persist();
        return "redirect:/matchers/" + encodeUrlPathSegment(matcher.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String MatcherController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Matcher());
        return "matchers/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String MatcherController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("matcher", Matcher.findMatcher(id));
        uiModel.addAttribute("itemId", id);
        return "matchers/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String MatcherController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("matchers", Matcher.findMatcherEntries(firstResult, sizeNo));
            float nrOfPages = (float) Matcher.countMatchers() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("matchers", Matcher.findAllMatchers());
        }
        return "matchers/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String MatcherController.update(@Valid Matcher matcher, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, matcher);
            return "matchers/update";
        }
        uiModel.asMap().clear();
        matcher.merge();
        return "redirect:/matchers/" + encodeUrlPathSegment(matcher.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String MatcherController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Matcher.findMatcher(id));
        return "matchers/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String MatcherController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Matcher matcher = Matcher.findMatcher(id);
        matcher.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/matchers";
    }
    
    String MatcherController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
