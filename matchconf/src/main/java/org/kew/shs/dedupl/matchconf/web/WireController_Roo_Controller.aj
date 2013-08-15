// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.kew.shs.dedupl.matchconf.web;

import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.kew.shs.dedupl.matchconf.Configuration;
import org.kew.shs.dedupl.matchconf.Matcher;
import org.kew.shs.dedupl.matchconf.Wire;
import org.kew.shs.dedupl.matchconf.WiredTransformer;
import org.kew.shs.dedupl.matchconf.web.WireController;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect WireController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String WireController.create(@Valid Wire wire, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, wire);
            return "wires/create";
        }
        uiModel.asMap().clear();
        wire.persist();
        return "redirect:/wires/" + encodeUrlPathSegment(wire.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String WireController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Wire());
        return "wires/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String WireController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("wire", Wire.findWire(id));
        uiModel.addAttribute("itemId", id);
        return "wires/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String WireController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("wires", Wire.findWireEntries(firstResult, sizeNo));
            float nrOfPages = (float) Wire.countWires() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("wires", Wire.findAllWires());
        }
        return "wires/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String WireController.update(@Valid Wire wire, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, wire);
            return "wires/update";
        }
        uiModel.asMap().clear();
        wire.merge();
        return "redirect:/wires/" + encodeUrlPathSegment(wire.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String WireController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Wire.findWire(id));
        return "wires/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String WireController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Wire wire = Wire.findWire(id);
        wire.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/wires";
    }
    
    void WireController.populateEditForm(Model uiModel, Wire wire) {
        uiModel.addAttribute("wire", wire);
        uiModel.addAttribute("configurations", Configuration.findAllConfigurations());
        uiModel.addAttribute("matchers", Matcher.findAllMatchers());
        uiModel.addAttribute("wiredtransformers", WiredTransformer.findAllWiredTransformers());
    }
    
    String WireController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
