// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.kew.shs.dedupl.matchconf.web;

import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.kew.shs.dedupl.matchconf.Configuration;
import org.kew.shs.dedupl.matchconf.Reporter;
import org.kew.shs.dedupl.matchconf.web.ReporterController;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect ReporterController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String ReporterController.create(@Valid Reporter reporter, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, reporter);
            return "reporters/create";
        }
        uiModel.asMap().clear();
        reporter.persist();
        return "redirect:/reporters/" + encodeUrlPathSegment(reporter.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String ReporterController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Reporter());
        return "reporters/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String ReporterController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("reporter", Reporter.findReporter(id));
        uiModel.addAttribute("itemId", id);
        return "reporters/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String ReporterController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("reporters", Reporter.findReporterEntries(firstResult, sizeNo));
            float nrOfPages = (float) Reporter.countReporters() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("reporters", Reporter.findAllReporters());
        }
        return "reporters/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String ReporterController.update(@Valid Reporter reporter, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, reporter);
            return "reporters/update";
        }
        uiModel.asMap().clear();
        reporter.merge();
        return "redirect:/reporters/" + encodeUrlPathSegment(reporter.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String ReporterController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Reporter.findReporter(id));
        return "reporters/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String ReporterController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Reporter reporter = Reporter.findReporter(id);
        reporter.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/reporters";
    }
    
    void ReporterController.populateEditForm(Model uiModel, Reporter reporter) {
        uiModel.addAttribute("reporter", reporter);
        uiModel.addAttribute("configurations", Configuration.findAllConfigurations());
    }
    
    String ReporterController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
